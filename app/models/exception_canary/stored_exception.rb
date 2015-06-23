module ExceptionCanary
  class StoredException < ActiveRecord::Base
    belongs_to :rule

    paginates_per 50

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
  end
end
