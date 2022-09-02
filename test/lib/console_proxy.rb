# frozen-string-literal: true

require 'logger'

require_relative '../test_helper'
require_relative '../../lib/named_logger'

class ConsoleProxyTest < Minitest::Test
  def test_stdout
    # config = NamedLogger::Configuration.new
    # config.disabled = true
    # logger = NamedLogger::LoggerBuilder.new(nil).build(config)
    logger = Logger.new(nil)
    proxy = NamedLogger::ConsoleProxy.new(logger)

    # proxy.debug { Hash.new }

    assert_output("foo\n") do
      proxy.debug { 'foo' }
    end

    assert_output("foo: bar\n") do
      proxy.info('foo') { 'bar' }
    end
  end

  def test_stdout_when_disabled
    config = NamedLogger::Configuration.new
    config.disabled = true

    builder = NamedLogger::LoggerBuilder.new(nil)
    logger = builder.build(config)

    assert_silent { logger.info('foo') }
  end
end
