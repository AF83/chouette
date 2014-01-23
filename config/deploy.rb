require 'capistrano/ext/multistage'
require './config/boot'

set :stages, %w(sandbox unstable staging production)
set :application, "chouette2"
set :scm, :git
set :repository,  "https://github.com/afimb/chouette2.git"
set :deploy_to, "/var/www/chouette2"
set :use_sudo, false
default_run_options[:pty] = true
set :group_writable, true
set :rake, "bundle exec rake"
set :keep_releases, 4
set :rails_env, "production" #added for delayed job
set :user, "mflorisson"
set :deploy_via, :copy
set :copy_via, :scp
set :copy_exclude, ".git/*"
ssh_options[:forward_agent] =   true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

after "deploy:update", "deploy:cleanup", "deploy:group_writable"
after "deploy:update_code", "deploy:symlink_shared", "deploy:chouette_command", "deploy:gems"
# ugly workaround for bug https://github.com/capistrano/capistrano/issues/81
before "deploy:assets:precompile", "deploy:symlink_shared"
after "deploy:restart", "delayed_job:restart"
after "deploy:migrate", "deploy:migrate_tenants"

# If you want to use command line options, for example to start multiple workers,
# define a Capistrano variable delayed_job_args:
#
#   set :delayed_job_args, "-n 2"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

 # Prevent errors when chmod isn't allowed by server
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')} && (chmod g+w #{dirs.join(' ')} || true)"
  end

  desc "Runs rake task which migrates database tables for all tenants"
  task :migrate_tenants do
    run "cd #{release_path} && RAILS_ENV=production bundle exec rake apartment:migrate"
  end

  desc "Install gems"
  task :gems, :roles => :app do
    run "cd #{release_path} && umask 02 && bundle install --path=#{shared_path}/bundle --without=development:test:cucumber"
  end

  desc "Symlinks shared configs and folders on each release"
  task :symlink_shared, :except => { :no_release => true }  do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/"
  end

  desc "Install chouette command"
  task :chouette_command, :except => { :no_release => true }  do
    run "mkdir -p /var/lib/chouette/imports"
    run "mkdir -p /var/lib/chouette/imports"
    run "mkdir -p /var/lib/chouette/validations"
    run "mkdir -p /usr/local/opt/chouette-command/"
  end

  desc "Make group writable all deployed files"
  task :group_writable do
    run "sudo /usr/local/sbin/cap-fix-permissions /var/www/chouette2"
  end

  # desc "Generate jekyll static sites"
  # task :jekyll, :except => { :no_release => true }  do
  #   run "cd #{release_path} && jekyll --auto doc/functional public/help"
  # end

  desc "tail log files"
  task :tail, :roles => :app do
    #run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
    run "tail -f /var/log/syslog" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end

end

namespace :delayed_job do
  task :restart do
    run "sudo /etc/init.d/chouette2 restart"
  end
end
