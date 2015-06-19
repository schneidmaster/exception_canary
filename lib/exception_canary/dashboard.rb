module ExceptionCanary
  class Dashboard < ::Rails::Engine
    isolate_namespace ExceptionCanary

    require 'less-rails'
    require 'react-rails'
    require 'jquery-rails'
  end
end
