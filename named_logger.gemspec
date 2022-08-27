require_relative 'lib/named_logger/version.rb'

Gem::Specification.new do |s|
  s.name        = 'named_logger'
  s.version     = NamedLogger::Version::VERSION
  s.summary     = 'A standard logger wrapper.'
  s.description = 'A wrapper around the standard logger, allowing to add loggers dynamically.'
  s.author      = 'Alexander Mandrikov'
  s.email       = 'mandrikov@pm.me'
  s.files       = ['lib/named_logger.rb']
  s.homepage    = 'https://github.com/nunsez/named_logger.git'
  s.license     = 'Apache-2.0'

  s.required_ruby_version = '>= 3.0', '< 4'
end
