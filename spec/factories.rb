FactoryGirl.define do

  factory :referential do |f|
    f.sequence(:name) { |n| "Test #{n}" }
    f.sequence(:slug) { |n| "test_#{n}" }
  end

  factory :user do |f|
    f.sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    f.password "secret"
    f.password_confirmation "secret"
  end

  factory :import do |f|
    f.resources { Rack::Test::UploadedFile.new 'spec/fixtures/neptune.zip', 'application/zip', false }
    f.association :referential
  end

  factory :import_log_message do |f|
    f.association :import
    f.sequence(:key) { "key_#{n}" }
  end

end
