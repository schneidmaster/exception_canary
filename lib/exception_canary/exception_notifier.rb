module ExceptionNotifier
  # Current syntax for notifying exceptions.
  class << self
    def notify_exception(exception, options = {})
      e = ExceptionCanary.create_exception!(exception, options)
      return false if ExceptionCanary.suppress_exception?(e)
      return false if ignored_exception?(options[:ignore_exceptions], exception)
      return false if ignored?(exception, options)
      selected_notifiers = options.delete(:notifiers) || notifiers
      [*selected_notifiers].each do |notifier|
        fire_notification(notifier, exception, options.dup)
      end
      true
    end
  end

  # Deprecated syntax for notifying exceptions.
  class Notifier
    class << self
      def exception_notification(env, exception, options = {}, default_options = {})
        e = ExceptionCanary.create_exception!(exception, options)
        return false if ExceptionCanary.suppress_exception?(e)

        load_custom_views

        @env        = env
        @exception  = exception
        @options    = options.reverse_merge(env['exception_notifier.options'] || {}).reverse_merge(default_options)
        @kontroller = env['action_controller.instance'] || MissingController.new
        @request    = ActionDispatch::Request.new(env)
        @backtrace  = exception.backtrace ? clean_backtrace(exception) : []
        @sections   = @options[:sections]
        @data       = (env['exception_notifier.exception_data'] || {}).merge(options[:data] || {})
        @sections += %w(data) unless @data.empty?

        compose_email
      end

      def background_exception_notification(exception, options = {}, default_options = {})
        e = ExceptionCanary.create_exception!(exception, options)
        return false if ExceptionCanary.suppress_exception?(e)

        load_custom_views

        @exception = exception
        @options   = options.reverse_merge(default_options)
        @backtrace = exception.backtrace || []
        @sections  = @options[:background_sections]
        @data      = options[:data] || {}

        compose_email
      end
    end
  end
end
