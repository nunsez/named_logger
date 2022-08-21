require_relative 'lib/named_logger/version.rb'

Gem::Specification.new do |s|
  s.name        = 'named_logger'
  s.version     = NamedLogger.version
  s.summary     = 'A wrapper around the standard logger, allowing to add loggers dynamically'
  s.description = s.summary
  s.author      = 'Alexander Mandrikov'
  s.email       = 'mandrikov@pm.me'
  s.files       = ['lib/named_logger.rb']
  s.homepage    = 'https://github.com/nunsez/named_logger.git'
  s.license     = 'Apache License 2.0'
end