module ExceptionCanary
  module ApplicationHelper
    def format_time(time)
      time = Time.parse(time) if time.is_a? String
      time.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
