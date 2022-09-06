# frozen-string-literal: true

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/test/'
  end
end

require 'fileutils'
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
    config.dirname = tmp_dirname

    tmp_name = SecureRandom.hex
    config.filename = proc { tmp_name }

    config
  end

  def tmp_dirname
    File.join(Dir.tmpdir, 'named_logger')
  end

  def forbidden_dir
    dirname = File.join(tmp_dirname, 'forbidden')
    Dir.mkdir(dirname) unless Dir.exist?(dirname)
    FileUtils.chmod(0400, dirname)
    dirname
  end

  def build_non_existent_temp_dirname
    dirname = File.join(tmp_dirname, 'nonexistent', rand(100).to_s, rand(100).to_s)
    FileUtils.remove_dir(somedir) if Dir.exist?(dirname)
    dirname
  end
end
