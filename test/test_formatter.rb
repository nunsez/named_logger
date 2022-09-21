# frozen-string-literal: true

require 'helper'

class TestFormatter < Minitest::Test
  class CustomFormatter < NamedLogger::Formatter
    def call(severity, time, progname, message)
      "#{message}:#{progname}\n"
    end
  end

  def test_custom_formatter
    config = temp_logger_config
    config.formatter = CustomFormatter.new
    logger = logger_builder.test(config: config)

    logger.info('progname') { 'message!' }
    log_content = File.read(logger.filepath)

    assert_match(/\nmessage!:progname\n/, log_content)
  end
end
