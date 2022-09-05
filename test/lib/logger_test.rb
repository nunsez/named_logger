# frozen-string-literal: true

require 'test_helper'
require 'securerandom'

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
    config = NamedLogger::Configuration.new
    config.dirname = File.join(Dir.tmpdir, 'named_logger')
    tmp_name = SecureRandom.hex
    config.filename = proc { tmp_name }

    logger = NamedLogger.baz(config: config)
    message = SecureRandom.uuid

    logger.debug('uuid') { message }

    log_content = File.read(logger.filepath)
    assert_match(/DEBUG -- uuid: #{message}/, log_content)
  end
end
