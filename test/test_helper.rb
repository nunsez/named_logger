# frozen-string-literal: true

require 'minitest/autorun'
require 'named_logger'

class Minitest::Test
  parallelize_me!
end
