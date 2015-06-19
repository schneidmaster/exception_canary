require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require 'exception_canary'

module Dummy
  class Application < Rails::Application; end
end
