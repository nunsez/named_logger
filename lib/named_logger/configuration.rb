# frozen-string-literal: true

require 'logger'

require_relative 'formatter'
require_relative 'severity'

module NamedLogger
  class Configuration
    attr_accessor :disabled, :formatter, :console_max_message_size,
                  :console_proxy, :dirname, :filename

    attr_reader :level

    def initialize(**kwargs)
      set_defaults
      assign_init_settings(kwargs)
    end

    def assign_init_settings(settings)
      settings.each do |property, value|
        method = "#{property}=".to_sym
        public_send(method, value)
      end
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
      when 'debug'  then Severity::DEBUG
      when 'info'   then Severity::INFO
      when 'warn'   then Severity::WARN
      when 'error'  then Severity::ERROR
      when 'fatal'  then Severity::FATAL
      else Severity::UNKNOWN
      end
    end

    def integer_to_level(severity)
      if Range.new(Severity::DEBUG, Severity::UNKNOWN).cover?(severity)
        severity
      else
        Severity::UNKNOWN
      end
    end
  end
end
