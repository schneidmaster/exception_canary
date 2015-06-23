module ExceptionCanary
  module RulesHelper
    def sortable(column, title = nil)
      title ||= column.titleize
      icon =
        if column == sort_column
          (sort_direction == 'asc' ? '<i class="icon-chevron-up"></i>' : '<i class="icon-chevron-down"></i>')
        end
      css_class = column == sort_column ? 'current' : nil
      direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
      link_to "#{title} #{icon}".html_safe, { sort: column, direction: direction }, class: css_class
    end

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
