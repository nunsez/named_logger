# frozen-string-literal: true

require 'test_helper'

class LoggerTest < Minitest::Test
  def test_config_respects_global_parameters
    builder = test_builder(level: :fatal)
    logger = builder.foo

    assert_equal NamedLogger::Severity::FATAL, builder.config.level
    assert_equal builder.config.level, logger.config.level
  end

  def test_config_respects_init_parameters
    builder = test_builder(disabled: false, level: :fatal)
    logger = builder.foo(level: :info)

    assert_equal NamedLogger::Severity::INFO, logger.config.level
    assert_equal logger.config.level, logger.level
  end

  def test_write_to_file
    logger = test_builder.file_writer(config: temp_logger_config)
    message = rand(100)

    logger.debug('rand') { message }

    log_content = File.read(logger.filepath)
    assert_match(/DEBUG -- rand: #{message}/, log_content)
  end

  def test_respond_to_logger_name
    builder = test_builder
    builder.random_name

    assert_operator builder, :respond_to?, :random_name
  end
end
