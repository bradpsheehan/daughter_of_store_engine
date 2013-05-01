require 'simplecov'

SimpleCov.start 'rails' do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
end


ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.include Rails.application.routes.url_helpers
  config.include Sorcery::TestHelpers::Rails

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

