 [![Build Status](https://travis-ci.org/schneidmaster/exception_canary.svg?branch=master)](https://travis-ci.org/schneidmaster/exception_canary)

# exception_canary

exception_canary is a mountable, configurable Rails engine to notify you only of new or important exceptions in your application, designed as a drop-in replacement (actually scaffolding) for [exception_notification](https://github.com/smartinez87/exception_notification). and [exception_notification-rake](https://github.com/nikhaldi/exception_notification-rake).

**Only compatible with Rails 3 - no present Rails 4 support.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exception_canary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_canary

You will also need to install the migrations for the exception_canary tables:

    $ rake exception_canary:install:migrations

## Usage

exception_canary is build directly on top of [exception_notification](https://github.com/smartinez87/exception_notification). and [exception_notification-rake](https://github.com/nikhaldi/exception_notification-rake), so all of the configuration options you know and love still work. Neato!

Specifically, check out the [Getting Started](https://github.com/smartinez87/exception_notification#getting-started) section of exception_notification and the [Usage](https://github.com/nikhaldi/exception_notification-rake#usage) section of exception_notification-rake. You will need to do all of this setup exactly as before.

Next, you will need to mount exception_canary's admin interface in your application. This allows you to see and manipulate groups and stored exceptions. exception_canary stores all exceptions in the database to permit you to retroactively search them, apply groups, or recover data if something is being suppressed when it shouldn't be.

Finally, exception_canary needs to know where it lives at so it can generate email links. If you just mount the engine without naming the route, you don't need to do anything. If exception_canary lives anywhere other than `:exception_canary_url` (e.g. you `mount ... as: some_url`), you must add the following line to your configuration in each environment:

```ruby
Your::Application.configure do
  ...
  config.exception_canary_root = :some_other_exception_canary_url
  ...
end
```

You may also define this as an absolute path, e.g.:

```ruby
Your::Application.configure do
  ...
  config.exception_canary_root = 'https://myapp.io/some_exception_canary_url'
  ...
end
```

## Running Tests

You'll need to set up the database, install dependencies, and run specs like so:

    $ rake db:create
    $ rake db:migrate
    $ rake app:db:test:prepare
    $ rspec

## Authorship

Written by Zach Schneider for [Aha!, the world's #1 product roadmap software](http://www.aha.io/)

## Contributing

1. Fork it ( https://github.com/schneidmaster/exception_canary/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
