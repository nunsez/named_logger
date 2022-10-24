# frozen-string-literal: true

require 'logger'

module NamedLogger
  class Formatter < ::Logger::Formatter
    LOG_FORMAT = "[%s] %5s -- %s: %s\n"
    DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def call(severity, time, progname, message)
      format(LOG_FORMAT, time.strftime(DATETIME_FORMAT), severity, progname, msg2str(message))
    end
  end
end
