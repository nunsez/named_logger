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

  # This method creates an instance of the module for better parallel testing.
  # Use it instead of NamedLogger from lib directory.
  def logger_builder(**options)
    Module.new.tap do |mod|
      mod.extend(NamedLogger::LoggerBuilder)

      mod.setup do |config|
        config.disabled = true # disabled by default
        config.dirname = tmp_dirname
        config.assign(options)
      end
    end
  end

  def temp_logger_config
    NamedLogger::Configuration.new.tap do |config|
      config.dirname = tmp_dirname

      fixed_tmp_name = SecureRandom.hex
      config.filename = proc { fixed_tmp_name }
    end
  end

  def forbidden_dir
    File.join(tmp_dirname, 'forbidden').tap do |dirname|
      FileUtils.mkdir(dirname, mode: 0400) unless Dir.exist?(dirname)
    end
  end

  def build_non_existent_temp_dirname
    File.join(tmp_dirname, 'nonexistent').tap do |dirname|
      FileUtils.remove_dir(dirname) if Dir.exist?(dirname)
    end
  end

  def tmp_dirname
    File.join(Dir.tmpdir, 'named_logger').tap do |dirname|
      FileUtils.mkdir_p(dirname)
    end
  end
end
