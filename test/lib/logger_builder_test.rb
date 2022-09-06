# frozen-string-literal: true

require 'test_helper'

class LoggerTest < Minitest::Test
  def test_config_respects_global_parameters
    NamedLogger.setup do |config|
      config.disabled = true
      config.level = :fatal
    end

    logger = NamedLogger.foo

    assert_equal 4, NamedLogger.config.level
    assert_equal 4, logger.config.level
  end

  def test_config_respects_init_parameters
    config = NamedLogger::Configuration.new(disabled: true)
    logger = NamedLogger.bar(config: config)

    assert logger.config.disabled
  end

  def test_write_to_file
    logger = NamedLogger.file_writer(config: temp_logger_config)
    message = rand(100)

    logger.debug('rand') { message }

    log_content = File.read(logger.filepath)
    assert_match(/DEBUG -- rand: #{message}/, log_content)
  end

  def test_respond_to_logger_name
    config = NamedLogger::Configuration.new(disabled: true)
    NamedLogger.random_name(config: config)

    assert_operator NamedLogger, :respond_to?, :random_name
  end
end
