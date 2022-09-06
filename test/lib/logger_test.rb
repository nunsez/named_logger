# frozen-string-literal: true

require 'test_helper'

class LoggerTest < Minitest::Test
  def test_respects_init_parameters
    config = NamedLogger::Configuration.new(level: 3, formatter: proc {}, dirname: tmp_dirname)
    init_formatter = proc {}
    logger = NamedLogger::Logger.new(:foobar, formatter: init_formatter, level: 4, config: config)

    assert_equal init_formatter, logger.formatter
    assert_equal 4, logger.level
  end

  def test_creates_dir_if_not_exist
    config = NamedLogger::Configuration.new
    config.dirname = build_non_existent_temp_dirname

    logger = NamedLogger::Logger.new(:barbaz, config: config)

    assert_path_exists logger.dirname
  end

  def test_build_correct_filepath
    config = NamedLogger::Configuration.new
    config.filename = proc { 'n!' }
    config.dirname = File.join(tmp_dirname, 'foo')

    logger = NamedLogger::Logger.new(nil, config: config)

    expected_filepath = File.join(config.dirname, 'n!')
    assert_equal expected_filepath, logger.filepath
  end

  def test_with_console_proxy
    config = NamedLogger::Configuration.new(console_proxy: true)
    logger = NamedLogger::Logger.new(nil, config: config)

    assert_instance_of NamedLogger::ConsoleProxy, logger.logger
  end

  def test_without_console_proxy
    config = NamedLogger::Configuration.new(console_proxy: false)
    logger = NamedLogger::Logger.new(nil, config: config)

    refute_instance_of NamedLogger::ConsoleProxy, logger.logger
  end

  def test_disabled_logger_in_config_not_create_file
    config = NamedLogger::Configuration.new(disabled: true)
    logger = NamedLogger::Logger.new('bar', config: config)

    refute_path_exists logger.filepath
  end

  def test_disabled_logger_nil_name_not_create_file
    config = NamedLogger::Configuration.new(disabled: false)
    logger = NamedLogger::Logger.new(nil, config: config)

    refute_path_exists logger.filepath
  end

  def test_catch_sysacll_err_with_logger_stub
    config = NamedLogger::Configuration.new(dirname: forbidden_dir)

    assert_output(nil, /Permission denied/) do
      NamedLogger::Logger.new('noway', config: config)
    end
  end
end
