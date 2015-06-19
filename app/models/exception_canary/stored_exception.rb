module ExceptionCanary
  class StoredException < ActiveRecord::Base
    belongs_to :rule

    serialize :environment
    serialize :variables
  end
end
