ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'byebug'
require 'factory_girl_rails'
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  # Include FactoryGirl helper methods
  config.include FactoryGirl::Syntax::Methods
end
