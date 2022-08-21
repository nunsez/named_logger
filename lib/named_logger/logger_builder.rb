# frozen-string-literal: true

require 'logger'
require 'fileutils'

require_relative 'console_proxy'

module NamedLogger
  class LoggerBuilder
    attr_reader :name, :args, :kwargs, :config

    def initialize(name, *args, **kwargs)
      @name = name
      @args = args
      @kwargs = kwargs
    end

    def build(config)
      return logger_stub if config.disabled

      @config = config

      ensure_directory_existence

      logger = ::Logger.new(
        filepath,
        *args,
        formatter: config.formatter,
        level: config.level,
        **kwargs
      )

      config.console_proxy ? console_proxy.new(logger) : logger
    rescue SystemCallError => e
      warn "NamedLogger: #{e}"
      logger_stub
    end

    def ensure_directory_existence
      FileUtils.mkdir_p(dirname) unless Dir.exist?(dirname)
    end

    def filepath
      filepath = File.join(dirname, filename(name))
    end

    def dirname
      config.dirname
    end

    def filename(name)
      config.filename.call(name)
    end

    def logger_stub
      ::Logger.new(nil)
    end

    def console_proxy
      ConsoleProxy
    end
  end
end
