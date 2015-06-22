module ExceptionCanary
  module RulesHelper
    def action_name(action)
      case action
      when Rule::ACTION_NOTIFY
        'Notify'
      when Rule::ACTION_SUPPRESS
        'Suppress'
      end
    end

    def match_type_name(match_type)
      case match_type
      when Rule::MATCH_TYPE_EXACT
        'Exact'
      when Rule::MATCH_TYPE_REGEX
        'Regex'
      end
    end

    def active?(is_active)
      is_active ? 'Yes' : 'No'
    end
  end
end
