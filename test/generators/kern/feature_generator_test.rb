require "test_helper"
require "generators/kern/feature/feature_generator"

module Kern
  class FeatureGeneratorTest < Rails::Generators::TestCase
    tests Kern::FeatureGenerator

    destination File.expand_path("../../dummy/tmp/generators", __dir__)

    setup :prepare_destination

    setup do
      copy_routes_file
    end

    test "generates sessions feature" do
      run_generator %w[sessions]

      assert_file "app/models/user.rb"
      assert_file "app/models/session.rb"
      assert_file "app/models/current.rb"
      assert_file "app/controllers/sessions_controller.rb"
      assert_file "app/controllers/concerns/authentication.rb"
      assert_file "app/views/sessions"
      assert_file "config/routes.rb", /resource :session, only: %w\[new create destroy\]/

      assert_file "app/controllers/concerns/authentication.rb" do |content|
        assert_match(/redirect_to new_session_path/, content)
        assert_no_match(/kern\.new_session_path/, content)
      end
    end

    test "generates signups feature" do
      run_generator %w[signups]

      assert_file "app/models/user.rb"
      assert_file "app/models/session.rb"
      assert_file "app/models/current.rb"
      assert_file "app/controllers/signups_controller.rb"
      assert_file "app/views/signups"
      assert_file "config/routes.rb", /resource :signup, only: %w\[new create\]/

      assert_file "app/controllers/signups_controller.rb" do |content|
        assert_match(/redirect_to root_path/, content)

        assert_no_match(/main_app\.root_path/, content)
      end
    end

    test "generates passwords feature with mailer" do
      run_generator %w[passwords]

      assert_file "app/controllers/passwords_controller.rb"
      assert_file "app/views/passwords"
      assert_file "app/mailers/passwords_mailer.rb"
      assert_file "app/views/passwords_mailer/reset.html.erb"
      assert_file "app/views/passwords_mailer/reset.text.erb"
      assert_file "config/routes.rb", /resources :passwords, param: :token, only: %w\[new create edit update\]/

      assert_file "app/views/passwords_mailer/reset.html.erb" do |content|
        assert_match(/edit_password_url\(@user.password_reset_token\)/, content)
        assert_no_match(/kern\.edit_password_url(@user.password_reset_token)/, content)
      end

      assert_file "app/views/passwords_mailer/reset.text.erb" do |content|
        assert_match(/edit_password_url\(@user.password_reset_token\)/, content)
        assert_no_match(/kern\.edit_password_url(@user.password_reset_token)/, content)
      end
    end

    test "generates settings feature" do
      run_generator %w[settings]

      assert_file "app/controllers/settings_controller.rb"
      assert_file "app/controllers/settings/users_controller.rb"
      assert_file "app/views/settings"
      assert_file "config/routes.rb", /resource :settings, only: %w\[show\]/
      assert_file "config/routes.rb", /namespace :settings/
    end

    test "generates multiple features" do
      run_generator %w[sessions passwords]

      assert_file "app/models/user.rb"
      assert_file "app/controllers/sessions_controller.rb"
      assert_file "app/controllers/passwords_controller.rb"
      assert_file "app/views/sessions"
      assert_file "app/views/passwords"
    end

    test "raises error for invalid feature" do
      assert_raises(SystemExit) do
        run_generator %w[invalid_feature]
      end
    end

    private

    def copy_routes_file
      routes_path = File.join(destination_root, "config/routes.rb")

      FileUtils.mkdir_p(File.dirname(routes_path))
      File.write(routes_path, "Rails.application.routes.draw do\nend\n")
    end
  end
end
