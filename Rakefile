# frozen_string_literal: true

require "minitest/test_task"
require "standard/rake"

Minitest::TestTask.create

require "bundler/setup"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

require "bundler/gem_tasks"

namespace :assets do
  desc "Build Tailwind CSS for distribution"
  task :precompile do
    Dir.chdir("test/dummy") do
      sh "bundle exec tailwindcss -i app/assets/tailwind/application.css -o app/assets/builds/tailwind.kern.css"

      FileUtils.mkdir_p "../../app/assets/builds"
      FileUtils.cp(
        "app/assets/builds/tailwind.kern.css",
        "../../app/assets/builds/tailwind.kern.css"
      )
    end
  end
end

task default: %i[test standard]
task build: "assets:precompile"
