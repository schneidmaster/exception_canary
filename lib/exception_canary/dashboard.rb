module ExceptionCanary
  class Dashboard < ::Rails::Engine
    isolate_namespace ExceptionCanary

    require 'less-rails'
    require 'less-rails-bootstrap'
    require 'react-rails'
    require 'jquery-rails'

    # TODO: use rake exception_canary:install:migrations instead
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end
  end
end
