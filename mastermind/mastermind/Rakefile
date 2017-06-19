gem 'rspec'
require 'rspec/core/rake_task'

task :default => :spec

desc "run tests for this lab"

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = '-r ./spec/spec_helper'
  task.verbose = false
end
