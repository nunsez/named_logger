# frozen_string_literal: true

module NamedLogger; end

require 'delegate'
require 'fileutils'
require 'logger'
require 'singleton'
require_relative 'named_logger/version'
require_relative 'named_logger/logger'

module NamedLogger
  extend Version
  extend Logger
end
