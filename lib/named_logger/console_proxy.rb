# frozen-string-literal: true

require_relative 'configuration'

module NamedLogger
  class ConsoleProxy < ::SimpleDelegator
    ::Logger::Severity.constants.each do |severity|
      define_method severity.downcase do |progname = nil, &block|
        console_print(progname, block)

        super(progname, &block)
      end
    end

    private

    def console_print(progname = nil, block = nil)
      if !progname.nil? && block
        puts "#{inspect(progname)}: #{inspect(block.call)}"
      elsif !progname.nil?
        puts inspect(progname)
      elsif block
        puts inspect(block.call)
      end
    end

    def inspect(message)
      case message
      when String, Symbol, Numeric, Hash, TrueClass, FalseClass
        message
      when Array
        message.inspect
      else
        inspected = message.inspect
        inspected.size > max_message_size ? message : inspected
      end
    end

    def max_message_size
      Configuration.instance.console_max_message_size
    end
  end
end
