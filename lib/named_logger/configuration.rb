# frozen-string-literal: true

require 'singleton'
require 'logger'

require_relative 'formatter'

module NamedLogger
  class Configuration
    include Singleton

    attr_accessor :disabled, :formatter, :console_max_message_size,
                  :console_proxy, :dirname, :filename

    attr_reader :level

    def initialize
      set_defaults
    end

    def set_defaults
      self.disabled = false

      self.level = :debug
      self.formatter = Formatter.new
      self.dirname = File.join(__dir__, 'log', 'named_logger')
      self.filename = proc { |logger_name| "#{logger_name}.log" }

      self.console_proxy = false
      self.console_max_message_size = 512

      true
    end

    def level=(severity)
      @level =
        case severity.to_s.downcase
        when 'debug'  then ::Logger::DEBUG
        when 'info'   then ::Logger::INFO
        when 'warn'   then ::Logger::WARN
        when 'error'  then ::Logger::ERROR
        when 'fatal'  then ::Logger::FATAL
        else ::Logger::UNKNOWN
        end
    end
  end
end
