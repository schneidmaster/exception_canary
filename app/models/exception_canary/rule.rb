module ExceptionCanary
  class Rule < ActiveRecord::Base
    has_many :stored_exceptions

    validates :name, presence: true
    validates :action, presence: true
    validates :match_type, presence: true
    validates :value, presence: true

    attr_accessible :name, :action, :match_type, :value, :is_auto_generated

    calculated :exceptions_count, -> { 'select count(*) from exception_canary_stored_exceptions where exception_canary_stored_exceptions.rule_id = exception_canary_rules.id' }
    calculated :most_recent_exception, -> { 'select max(exception_canary_stored_exceptions.created_at) from exception_canary_stored_exceptions where exception_canary_stored_exceptions.rule_id = exception_canary_rules.id'}

    ACTION_NOTIFY   = 10
    ACTION_SUPPRESS = 20
    ACTIONS = [ACTION_NOTIFY, ACTION_SUPPRESS]

    MATCH_TYPE_EXACT = 10
    MATCH_TYPE_REGEX = 20
    MATCH_TYPES = [MATCH_TYPE_EXACT, MATCH_TYPE_REGEX]

    def notify?
      action == ACTION_NOTIFY
    end

    def suppress?
      action == ACTION_SUPPRESS
    end

    def auto_generated?
      is_auto_generated
    end

    def matches?(exception)
      case match_type
      when MATCH_TYPE_EXACT
        exception.title == value
      when MATCH_TYPE_REGEX
        !Regexp.new(value).match(exception.title).nil?
      end
    end
  end
end
