# frozen-string-literal: true

require 'logger'
require 'fileutils'
require 'forwardable'

require_relative 'configuration'
require_relative 'console_proxy'
require_relative 'severity'

module NamedLogger
  class LoggerBuilder
    extend Forwardable

    attr_reader :name, :args, :kwargs, :logger, :config

    def_instance_delegators :logger, *Severity.methods, :formatter

    def initialize(name, *args, **kwargs)
      @name = name
      @args = args
      @config = kwargs.fetch(:config) { Configuration.new }
      @kwargs = kwargs.except(:config)

      @logger = build_logger
    end

    def build_logger
      current_logger = config.disabled ? logger_stub : logger_device
      config.console_proxy ? console_proxy.new(current_logger, config: config) : current_logger
    end

    def logger_device
      ensure_directory_existence

      logger_base.new(
        filepath,
        *args,
        formatter: config.formatter,
        level: config.level,
        **kwargs
      )
    rescue SystemCallError => e
      warn "NamedLogger: #{e}"
      logger_stub
    end

    def ensure_directory_existence
      FileUtils.mkdir_p(dirname) unless Dir.exist?(dirname)
    end

    def filepath
      File.join(dirname, filename(name))
    end

    def dirname
      config.dirname
    end

    def filename(name)
      config.filename.call(name)
    end

    def logger_stub
      logger_base.new(nil)
    end

    def logger_base
      ::Logger
    end

    def console_proxy
      ConsoleProxy
    end
  end
end
