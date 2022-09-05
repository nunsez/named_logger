# frozen-string-literal: true

require 'minitest/autorun'
require 'named_logger'

class Minitest::Test
  parallelize_me!

  def setup
    super

    NamedLogger.config.disabled = true
  end
end
