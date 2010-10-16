require 'bundler'
require 'rspec'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
end

