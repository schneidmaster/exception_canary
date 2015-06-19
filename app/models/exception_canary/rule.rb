module ExceptionCanary
  class Rule < ActiveRecord::Base
    has_many :stored_exceptions

    scope :active, -> { where(is_active: true) }

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
