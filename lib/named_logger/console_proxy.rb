# frozen-string-literal: true

require 'delegate'

require_relative 'configuration'
require_relative 'severity'

module NamedLogger
  class ConsoleProxy < SimpleDelegator
    def initialize(logger, **kwargs)
      @config = kwargs.fetch(:config) { Configuration.new }
      __setobj__ logger
    end

    Severity.methods.each do |method|
      define_method method do |progname = nil, &block|
        console_print(progname, block)

        super(progname, &block)
      end
    end

    private

    attr_reader :config

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
      when String, Symbol
        message
      when Array
        message.inspect
      else
        inspected = message.inspect
        inspected.size > max_message_size ? message : inspected
      end
    end

    def max_message_size
      config.console_max_message_size
    end
  end
end
