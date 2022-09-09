# frozen-string-literal: true

require 'logger'

require_relative 'formatter'
require_relative 'severity'

module NamedLogger
  class Configuration
    include Severity

    attr_accessor :disabled, :formatter, :console_max_message_size,
                  :console_proxy, :dirname, :filename

    attr_reader :level

    def initialize(**settings)
      set_defaults
      assign(settings)
    end

    def assign(settings)
      settings.each do |property, value|
        method = "#{property}=".to_sym
        public_send(method, value)
      rescue NoMethodError
        # do nothing
      end

      self
    end

    def set_defaults
      self.disabled = false

      self.level = :debug
      self.formatter = Formatter.new
      self.dirname = File.join('log', 'named_logger')
      self.filename = proc { |logger_name| "#{logger_name}.log" }

      self.console_proxy = false
      self.console_max_message_size = 512

      true
    end

    def level=(severity)
      @level =
        case severity
        when Integer
          integer_to_level(severity)
        when String, Symbol
          string_to_level(severity)
        else
          raise 'wrong level value format!'
        end
    end

    private

    def string_to_level(severity)
      case severity.to_s.downcase
      when 'debug'  then DEBUG
      when 'info'   then INFO
      when 'warn'   then WARN
      when 'error'  then ERROR
      when 'fatal'  then FATAL
      else UNKNOWN
      end
    end

    def integer_to_level(severity)
      if Range.new(DEBUG, UNKNOWN).cover?(severity)
        severity
      else
        UNKNOWN
      end
    end
  end
end
