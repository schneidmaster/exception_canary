module ExceptionCanary
  class StoredException < ActiveRecord::Base
    belongs_to :group

    paginates_per 50

    attr_accessible :title, :backtrace, :environment, :variables, :klass

    serialize :environment
    serialize :variables

    scope :search, -> (term) { where('title LIKE ?', "%#{term}%") }

    def backtrace_summary
      if backtrace.length < 300
        backtrace
      else
        "#{backtrace[0...297]}..."
      end
    end

    def short_title
      lines = title.split("\n")
      if lines.count > 0
        "#{lines.first}..."
      else
        lines.first
      end
    end
  end
end
