module NamedLogger
  module Severity
    DEBUG   = 0
    INFO    = 1
    WARN    = 2
    ERROR   = 3
    FATAL   = 4
    UNKNOWN = 5

    class << self
      def methods
        %i[debug info warn error fatal unknown]
      end
    end
  end
end
