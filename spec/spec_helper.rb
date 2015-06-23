ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'byebug'
require 'database_cleaner'
require 'factory_girl_rails'
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'

  # Include FactoryGirl helper methods
  config.include FactoryGirl::Syntax::Methods

  # Clean database between specs.
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
