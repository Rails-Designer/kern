require "test_helper"
require "generators/kern/install/install_generator"

module Kern
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests Kern::InstallGenerator

    destination File.expand_path("../../dummy/tmp/generators", __dir__)

    setup :prepare_destination

    setup do
      copy_gemfile
      copy_routes_file
      copy_application_controller
    end

    test "adds required gems" do
      run_generator %w[--skip-migrations]

      assert_file "Gemfile" do |content|
        assert_match(/gem ['"]stripe['"]/, content)
        assert_match(/gem ['"]rails_icons['"]/, content)
      end
    end

    test "injects authentication into application controller" do
      run_generator %w[--skip-migrations]

      assert_file "app/controllers/application_controller.rb", /include Authentication/
    end

    test "injects kern layout into application controller" do
      run_generator %w[--skip-migrations]

      assert_file "app/controllers/application_controller.rb", /layout "kern\/application"/
    end

    test "creates configuration files" do
      run_generator %w[--skip-migrations]

      assert_file "config/configurations/stripe.yml"
      assert_file "config/configurations/plans.yml"
      assert_file "config/configurations/urls.yml"
      assert_file "config/configurations/README.md"
    end

    test "adds engine route" do
      run_generator %w[--skip-migrations]

      assert_file "config/routes.rb", /mount Kern::Engine => "\/"/
    end

    private

    def copy_gemfile
      gemfile_path = File.join(destination_root, "Gemfile")

      FileUtils.mkdir_p(File.dirname(gemfile_path))
      File.write(gemfile_path, "source 'https://rubygems.org'\n\n# gem \"bcrypt\"\n")
    end

    def copy_routes_file
      routes_path = File.join(destination_root, "config/routes.rb")

      FileUtils.mkdir_p(File.dirname(routes_path))
      File.write(routes_path, "Rails.application.routes.draw do\nend\n")
    end

    def copy_application_controller
      controller_path = File.join(destination_root, "app/controllers/application_controller.rb")

      FileUtils.mkdir_p(File.dirname(controller_path))
      File.write(controller_path, "class ApplicationController < ActionController::Base\nend\n")
    end
  end
end
