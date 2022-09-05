# frozen-string-literal: true

require 'test_helper'

class ConfigurationTest < Minitest::Test
  def setup
    super

    @config = NamedLogger.config
  end

  def test_same_config
    otherconfig = NamedLogger.config
    assert_equal @config, otherconfig
  end

  def test_level_assign_string
    @config.level = :foo
    assert_equal 5, @config.level

    @config.level = 'fatal'
    assert_equal 4, @config.level

    @config.level = 'ERROR'
    assert_equal 3, @config.level

    @config.level = 'Warn'
    assert_equal 2, @config.level

    @config.level = :Info
    assert_equal 1, @config.level

    @config.level = :debug
    assert_equal 0, @config.level
  end

  def test_level_assign_integer
    @config.level = 2
    assert_equal 2, @config.level

    @config.level = -42
    assert_equal 5, @config.level

    @config.level = 42
    assert_equal 5, @config.level
  end

  def test_level_wrong_value_format
    assert_raises(StandardError) { @config.level = 4.2 }
  end

  def test_default_filename_proc
    assert_equal 'foo.log', @config.filename.call('foo')
  end

  def test_assign_init_settings
    config = NamedLogger::Configuration.new(disabled: true, level: :fatal)

    assert config.disabled
    assert_equal NamedLogger::Severity::FATAL, config.level
  end
end
