# frozen-string-literal: true

require_relative 'configuration'
require_relative 'console_proxy'

module NamedLogger
  module Logger
    def method_missing(name, ...)
      loggers[name] ||= build_logger(name, ...)
    end

    def respond_to_missing?(name, include_private = false)
      loggers.key?(name) || super
    end

    def setup
      yield(config) if block_given?

      config
    end

    def config
      Configuration.instance
    end

    def disabled?
      config.disabled
    end

    private

    def loggers
      @loggers ||= {}
    end

    def build_logger(name, *args, **kwargs)
      return ::Logger.new(nil) if disabled?

      FileUtils.mkdir_p(dirname) unless Dir.exist?(dirname)
      filepath = File.join(dirname, filename(name))
      logger = ::Logger.new(filepath, *args, formatter: formatter, **kwargs)

      config.console_proxy ? ConsoleProxy.new(logger) : logger
    rescue SystemCallError => e
      warn "NamedLogger: #{e}"
      ::Logger.new(nil)
    end

    def dirname
      config.dirname
    end

    def filename(name)
      config.filename.call(name, config.environment)
    end

    def formatter
      config.formatter
    end
  end
end
