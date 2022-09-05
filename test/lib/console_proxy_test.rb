# frozen-string-literal: true

require 'logger'
require 'test_helper'

class ConsoleProxyTest < Minitest::Test
  def test_stdout
    config = NamedLogger::Configuration.new(disabled: true, console_proxy: true)
    logger = NamedLogger::LoggerBuilder.new(nil, config: config)

    assert_output("foo\n") do
      logger.debug { 'foo' }
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
    logger = NamedLogger::LoggerBuilder.new(nil, config: config)
    obj = Class.new do
      def initialize(len)
        @foo = 'bar ' * len
      end
    end.new(length)

    assert_output(/.{,#{length}}/) do
      logger.info(obj)
    end
  end

  def test_stdout_when_console_disabled
    config = NamedLogger::Configuration.new(disabled: true, console_proxy: false)
    logger = NamedLogger::LoggerBuilder.new(nil, config: config)

    assert_silent { logger.info('foo') }
  end
end
