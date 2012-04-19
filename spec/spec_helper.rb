# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Add this to load Capybara integration:
require 'capybara/rspec'
require 'capybara/rails'

# FIXME FactoryGirl not found in jenkins build #13
unless defined?(FactoryGirl)
  require 'factory_girl'
  require 'spec/factories.rb'
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'will_paginate/array'
require 'database_cleaner'

RSpec.configure do |config|
  DatabaseCleaner.logger = Rails.logger
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction

    begin
      Apartment.database_names.each do |database|
        Apartment::Database.drop(database)
      end
    rescue
      # FIXME referentials table not found in jenkins build #13
    end

    DatabaseCleaner.clean_with(:truncation, {:except => %w[spatial_ref_sys geometry_columns]} )
  end

  config.before(:each) do
    Apartment::Database.switch(nil)
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Apartment::Database.switch(nil)
  end

end
