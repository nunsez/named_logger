# frozen-string-literal: true

require_relative 'formatter'

module NamedLogger
  class Configuration
    include Singleton

    attr_accessor :disabled, :formatter, :console_max_message_size, :console_proxy,
                  :dirname, :filename, :severity, :environment

    def initialize
      set_defaults
    end

    def set_defaults
      self.disabled = false

      self.severity = :debug #! check docs
      self.environment = nil
      self.formatter = Formatter.new
      self.dirname = File.join(__dir__, 'log', 'named_logger')
      self.filename = ->(logger_name, env = nil) { [logger_name, env, 'log'].compact.join('.') }

      self.console_proxy = false
      self.console_max_message_size = 512

      true
    end
  end
end
