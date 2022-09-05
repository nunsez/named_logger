# frozen-string-literal: true

require_relative 'configuration'
require_relative 'logger_builder'

module NamedLogger
  module Logger
    def method_missing(name, *args, **kwargs)
      loggers[name] ||= build_logger(name, *args, **kwargs)
    end

    def respond_to_missing?(name, include_private = false)
      loggers.key?(name) || super
    end

    def setup
      yield(config) if block_given?
    end

    def config
      @config ||= Configuration.new
    end

    private

    def loggers
      @loggers ||= {}
    end

    def build_logger(name, *args, **kwargs)
      LoggerBuilder.new(name, *args, config: config, **kwargs)
    end
  end
end
