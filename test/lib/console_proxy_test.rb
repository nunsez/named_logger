# frozen-string-literal: true

require 'test_helper'

class ConsoleProxyTest < Minitest::Test
  class CustomVarLength
    def initialize(len)
      @foo = 'bar ' * len
    end
  end

  def test_stdout
    config = NamedLogger::Configuration.new(disabled: true, console_proxy: true)
    logger = NamedLogger::Logger.new(nil, config: config)

    assert_output("[1, 2, 3]\n") do
      logger.debug { [1, 2, 3] }
    end

    assert_output("foo: {}\n") do
      logger.info('foo') { Hash.new }
    end
  end

  def test_stdout_length
    length = 100
    config = NamedLogger::Configuration.new(disabled: true,
                                            console_proxy: true,
                                            console_max_message_size: length)
    logger = NamedLogger::Logger.new(nil, config: config)

    assert_output(/.{,#{length}}/) do
      logger.info(CustomVarLength.new(length))
    end
  end

  def test_stdout_when_console_disabled
    config = NamedLogger::Configuration.new(disabled: true, console_proxy: false)
    logger = NamedLogger::Logger.new(nil, config: config)

    assert_silent { logger.info('foo') }
  end
end
