# frozen-string-literal: true

module NamedLogger
  MAJOR = 0
  MINOR = 1
  TINY  = 0

  VERSION = [MAJOR, MINOR, TINY].join('.').freeze

  class << self
    def version
      VERSION
    end
  end
end
