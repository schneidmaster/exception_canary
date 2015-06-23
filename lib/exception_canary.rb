require 'exception_notification'
require 'exception_notifier/rake'

require 'exception_canary/dashboard'
require 'exception_canary/exception_notifier'
require 'exception_canary/version'

module ExceptionCanary
  class << self
    def create_exception!(exception, options)
      variables = {}
      unless options[:env].nil? || options[:env]['action_controller.instance'].nil?
        options[:env]['action_controller.instance'].instance_variables.each do |v|
          k = v.to_s
          variables[k] = options[:env]['action_controller.instance'].instance_variable_get(k) unless k.include? '@_'
        end
      end

      title = "(#{exception.class}) \"#{exception.message}\""
      title = "#{ENV['action_controller.instance']} #{title}" if ENV['action_controller.instance']
      ExceptionCanary::StoredException.create! title: title, backtrace: exception.backtrace.join("\n"), environment: ENV.to_hash, variables: variables, klass: exception.class.to_s
    end

    def suppress_exception?(se)
      se.rule = ExceptionCanary::Rule.find { |r| r.matches?(se) }
      se.rule ||= ExceptionCanary::Rule.create!(name: se.title, action: ExceptionCanary::Rule::ACTION_NOTIFY, match_type: ExceptionCanary::Rule::MATCH_TYPE_EXACT, value: se.title)
      se.save!
      se.rule.suppress?
    end
  end
end
