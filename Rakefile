# frozen-string-literal: true

require 'fileutils'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
end

desc 'Test coverage'
task :coverage do
  coverage_dir = File.join(__dir__, 'coverage')
  FileUtils.remove_dir(coverage_dir) if Dir.exist?(coverage_dir)

  ENV['COVERAGE'] = '1'
  Rake::Task['test'].invoke
end

desc 'Run tests'
task default: :test
