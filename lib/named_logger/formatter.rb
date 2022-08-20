# frozen-string-literal: true

module NamedLogger
  class Formatter < ::Logger::Formatter
    def initialize
      super

      @datetime_format = '%Y-%m-%d %H:%M:%S '
    end
  end
end
