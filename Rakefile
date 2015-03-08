require 'rubygems'
require 'bundler'
require 'rake'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

task default: [:test]

task :test do
  ruby ''
end
