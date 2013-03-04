require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  STDERR.puts e.message
  STDERR.puts "Run `gem install bundler` to install Bundler."
  exit e.status_code
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bundler/gem_tasks'
VERSION = File.read("VERSION").chomp

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec

