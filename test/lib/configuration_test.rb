# frozen-string-literal: true

require_relative '../test_helper'
require_relative '../../lib/named_logger/configuration'

class ConfigurationTest < Minitest::Test
  include NamedLogger

  def test_same_config
    config1 = Configuration.instance
    config2 = Configuration.instance

    assert_equal config1, config2
  end

  def test_level_assign_string
    config = Configuration.instance

    config.level = :foo
    assert_equal 5, config.level

    config.level = 'fatal'
    assert_equal 4, config.level

    config.level = 'ERROR'
    assert_equal 3, config.level

    config.level = 'Warn'
    assert_equal 2, config.level

    config.level = :Info
    assert_equal 1, config.level

    config.level = :debug
    assert_equal 0, config.level
  end

  def test_level_assign_integer
    config = Configuration.instance

    config.level = 2
    assert_equal 2, config.level

    config.level = -42
    assert_equal 5, config.level

    config.level = 42
    assert_equal 5, config.level
  end

  def test_level_wrong_value_format
    config = Configuration.instance
    assert_raises(StandardError) { config.level = 4.2 }
  end

  def test_default_filename_proc
    config = Configuration.instance
    assert_equal 'foo.log', config.filename.call('foo')
  end
end
