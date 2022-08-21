# frozen-string-literal: true

require 'logger'

module NamedLogger
  class Formatter < ::Logger::Formatter
    def initialize
      super

      # TODO replace format to DatetimeFormat constant and delete last space
      # https://github.com/ruby/ruby/commit/a8b11b5cdd5fedd30a65e60bdae4c00d259d4191
      @datetime_format = '%Y-%m-%d %H:%M:%S '
    end
  end
end
