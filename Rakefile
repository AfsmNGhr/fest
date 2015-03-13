require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |task|
  file_list = FileList['spec/**/*_spec.rb']
  file_list -= ['spec/fest_spec.rb', 'spec/volume/volume_spec']
  task.pattern = file_list
end
task :default => :spec
