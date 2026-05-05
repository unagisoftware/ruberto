# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "rubocop/rake_task"

RuboCop::RakeTask.new

namespace :brakeman do
  desc "Run Brakeman security scanner"
  task :check do
    require "brakeman"
    Brakeman.run(app_path: ".", print_report: true, quiet: true)
  end
end

task default: %i[test rubocop]
