module ExceptionCanary
  class StoredException < ActiveRecord::Base
    belongs_to :rule

    serialize :environment
    serialize :variables

    def backtrace_summary
      if backtrace.length < 300
        backtrace
      else
        "#{backtrace[0..297]}..."
      end
    end
  end
end
