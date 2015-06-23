module ExceptionCanary
  class Dashboard < ::Rails::Engine
    isolate_namespace ExceptionCanary

    require 'calculated_attributes'
    require 'less-rails'
    require 'less-rails-bootstrap'
    require 'jquery-rails'
    require 'kaminari'
  end
end
