require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require 'before_commit'
spec = Gem::Specification.find_by_name 'before_commit'
load "#{spec.gem_dir}/lib/tasks/before_commit.rake"

task default: :spec
