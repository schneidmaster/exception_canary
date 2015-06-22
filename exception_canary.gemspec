# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exception_canary/version'

Gem::Specification.new do |spec|
  spec.name          = 'exception_canary'
  spec.version       = ExceptionCanary::VERSION
  spec.authors       = ['Zach Schneider']
  spec.email         = ['zach@aha.io']

  spec.summary       = 'exception_canary is a mountable, configurable Rails engine to notify you only of new or important exceptions in your application, designed as a drop-in replacement for exception_notification and exception_notification-rake.'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'exception_notification', '>= 3.0.1'
  spec.add_dependency 'exception_notification-rake', '>= 0.0.5'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'less-rails'
  spec.add_dependency 'less-rails-bootstrap', '~> 2.3.3'
  spec.add_dependency 'rails', '~> 3.2.21'
  spec.add_dependency 'react-rails'
  spec.add_dependency 'therubyracer'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_girl_rails', '~> 3.6.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sqlite3'
end
