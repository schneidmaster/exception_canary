module ExceptionCanary
  class StoredException < ActiveRecord::Base
    belongs_to :group

    paginates_per 50

    attr_accessible :title, :backtrace, :environment, :variables, :klass

    serialize :environment
    serialize :variables

    scope :exception_search, -> (term) { where('title LIKE ?', "%#{term}%") }

    def backtrace_summary
      if backtrace.length < 300
        backtrace
      else
        "#{backtrace[0...297]}..."
      end
    end

    def short_title
      title.split("\n").first
    end
  end
end
