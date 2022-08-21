# frozen-string-literal: true

require_relative 'configuration'
require_relative 'logger_builder'

module NamedLogger
  module Logger
    def method_missing(name, ...)
      loggers[name] ||= logger_builder.new(name, ...).build(config)
    end

    def respond_to_missing?(name, include_private = false)
      loggers.key?(name) || super
    end

    def setup
      yield(config) if block_given?
    end

    def config
      Configuration.instance
    end

    private

    def loggers
      @loggers ||= {}
    end

    def logger_builder
      LoggerBuilder
    end
  end
end
