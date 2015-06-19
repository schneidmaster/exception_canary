 [![Build Status](https://travis-ci.org/schneidmaster/exception_canary.svg?branch=master)](https://travis-ci.org/schneidmaster/exception_canary)

 # exception_canary

exception_canary is a mountable, configurable Rails engine to notify you only of new or important exceptions in your application, designed as a drop-in replacement (actually scaffolding) for [exception_notification](https://github.com/smartinez87/exception_notification). and [exception_notification-rake](https://github.com/nikhaldi/exception_notification-rake).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exception_canary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_canary

## Usage

exception_canary is build directly on top of [exception_notification](https://github.com/smartinez87/exception_notification). and [exception_notification-rake](https://github.com/nikhaldi/exception_notification-rake), so all of the configuration options you know and love still work. Neato!

Specifically, check out the [Getting Started](https://github.com/smartinez87/exception_notification#getting-started) section of exception_notification and the [Usage](https://github.com/nikhaldi/exception_notification-rake#usage) section of exception_notification-rake. You will need to do all of this setup exactly as before.

Next, you will need to mount exception_canary's admin interface in your application. This allows you to see and manipulate rules and stored exceptions. exception_canary stores all exceptions in the database to permit you to retroactively search them, apply rules, or recover data if something is being suppressed when it shouldn't be.

Rules are applied in order - if rule #1 and rule #5 (in order as viewed in the dashboard) both match an exception, rule #5's action will be taken.

## Running Tests

exception_canary uses appraisal to test against multiple versions of Rails/ActiveRecord. You'll need to set up the database, install dependencies, and run specs like so:

1. rake db:migrate
2. rake app:db:test:prepare
3. appraisal install
4. appraisal rspec

## Authorship

Written by Zach Schneider for [Aha!, the world's #1 product roadmap software](http://www.aha.io/)

## Contributing

1. Fork it ( https://github.com/schneidmaster/exception_canary/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
