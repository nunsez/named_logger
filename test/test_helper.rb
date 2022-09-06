# frozen-string-literal: true

require 'minitest/autorun'
require 'named_logger'
require 'securerandom'

class Minitest::Test
  parallelize_me!

  def setup
    super

    NamedLogger.config.disabled = true
  end

  def temp_logger_config
    config = NamedLogger::Configuration.new
    config.dirname = File.join(Dir.tmpdir, 'named_logger')

    tmp_name = SecureRandom.hex
    config.filename = proc { tmp_name }

    config
  end
end
