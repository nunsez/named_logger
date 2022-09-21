# frozen-string-literal: true

require 'helper'

class TestConsoleProxy < Minitest::Test
  class CustomVarLength
    def initialize(len)
      @foo = 'bar ' * len
    end
  end

  def test_stdout
    logger = logger_builder(console_proxy: true).test

    assert_output("[1, 2, 3]\n") do
      logger.debug { [1, 2, 3] }
    end

    assert_output("foo: {}\n") do
      logger.info('foo') { Hash.new }
    end
  end

  def test_stdout_length
    length = 100
    logger = logger_builder(console_proxy: true, console_max_message_size: length).test

    assert_output(/.{,#{length}}/) do
      logger.info(CustomVarLength.new(length))
    end
  end

  def test_stdout_when_console_disabled
    logger = logger_builder(console_proxy: false).test
    assert_silent { logger.info('foo') }
  end
end
