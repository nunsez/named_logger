# frozen-string-literal: true

module NamedLogger
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    VERSION = [MAJOR, MINOR, PATCH].join('.').freeze

    def self.extended(othermod)
      othermod.const_set(:VERSION, VERSION)
    end
  end
end
