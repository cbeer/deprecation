module Deprecation
  module ClassMethods
    # Outputs a deprecation warning to the output configured by <tt>ActiveSupport::Deprecation.behavior</tt>
    #
    #   Deprecation.warn("something broke!")
    #   # => "DEPRECATION WARNING: something broke! (called from your_code.rb:1)"
    def warn(message = nil, callstack = caller)
      return if silenced
      deprecation_message(callstack, message).tap do |m|
        deprecation_behavior.each { |b| b.call(m, callstack) }
      end
    end

    # Silence deprecation warnings within the block.
    def silence
      old_silenced, @silenced = @silenced, true
      yield
    ensure
      @silenced = old_silenced
    end

    def collect
      old_behavior = self.class.deprecation_behavior
      deprecations = []
      self.deprecation_behavior = Proc.new do |message, callstack|
        deprecations << message
      end
      result = yield
      [result, deprecations]
    ensure
      self.class.deprecation_behavior = old_behavior
    end

    def deprecated_method_warning(method_name, options = nil)

      options ||= {}

      if options.is_a? String  or options.is_a? Symbol
        message = options
        options = {}
      end

      warning = "#{method_name} is deprecated and will be removed from #{options[:deprecation_horizon] || deprecation_horizon}"
      case message
        when Symbol then "#{warning} (use #{message} instead)"
        when String then "#{warning} (#{message})"
        else warning
      end
    end

    private
      def deprecation_message(callstack, message = nil)
        message ||= "You are using deprecated behavior which will be removed from the next major or minor release."
        message += '.' unless message =~ /\.$/
        "DEPRECATION WARNING: #{message} #{deprecation_caller_message(callstack)}"
      end

      def deprecation_caller_message(callstack)
        file, line, method = extract_callstack(callstack)
        if file
          if line && method
            "(called from #{method} at #{file}:#{line})"
          else
            "(called from #{file}:#{line})"
          end
        end
      end

      def extract_callstack(callstack)
        deprecation_gem_root = File.expand_path("../..", __FILE__) + "/"
        offending_line = callstack.find { |line| !line.start_with?(deprecation_gem_root) } || callstack.first
        if offending_line
          if md = offending_line.match(/^(.+?):(\d+)(?::in `(.*?)')?/)
            md.captures
          else
            offending_line
          end
        end
      end
  end
end
