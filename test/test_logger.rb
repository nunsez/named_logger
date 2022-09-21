# frozen-string-literal: true

require 'helper'

class TestLogger < Minitest::Test
  def test_respects_init_parameters
    init_formatter = proc { 0 }
    named_logger = logger_builder(disabled: false, level: 3, formatter: proc { 1 })
    logger = named_logger.foo(level: 4, formatter: init_formatter)

    assert_equal init_formatter, logger.formatter
    assert_equal 4, logger.level
  end

  def test_creates_dir_if_not_exist
    dirname = build_non_existent_temp_dirname
    logger = logger_builder(dirname: dirname, disabled: false).test

    assert_path_exists logger.dirname
  end

  def test_build_correct_filepath
    filename = proc { 'n!' }
    dirname = File.join(tmp_dirname, 'foo')
    logger = logger_builder(filename: filename, dirname: dirname).test

    expected_filepath = File.join(dirname, 'n!')
    assert_equal expected_filepath, logger.filepath
  end

  def test_with_console_proxy
    logger = logger_builder(console_proxy: true).test
    assert_instance_of NamedLogger::ConsoleProxy, logger.logger
  end

  def test_without_console_proxy
    logger = logger_builder(console_proxy: false).test
    refute_instance_of NamedLogger::ConsoleProxy, logger.logger
  end

  def test_disabled_logger_in_config_not_create_file
    logger = logger_builder(disabled: true).test
    refute_path_exists logger.filepath
  end

  def test_disabled_logger_nil_name_not_create_file
    config = NamedLogger::Configuration.new(disabled: false)
    logger = NamedLogger::Logger.new(nil, config: config)

    refute_path_exists logger.filepath
  end

  def test_catch_sysacll_err_with_logger_stub
    named_logger = logger_builder(disabled: false, dirname: forbidden_dir)

    assert_output(nil, /Permission denied/) do
      named_logger.noway
    end
  end
end
