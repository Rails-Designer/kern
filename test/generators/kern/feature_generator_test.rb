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

    test "generates billing feature" do
      copy_workspace_model
      copy_routes_file_with_settings_namespace

      run_generator %w[billing]

      assert_file "config/routes.rb", /resource :subscriptions, module: :billing_profiles, only: %w\[create edit\]/
      assert_file "config/routes.rb", /resource :subscriptions, only: %w\[show\]/

      assert_file "config/initializers/stripe.rb"

      assert_file "app/models/billing_profile.rb"
      assert_file "app/models/billing_profile/subscription.rb"
      assert_file "app/models/workspace/billable.rb"

      assert_file "app/models/workspace.rb", /include Billable/

      assert_file "app/views/settings/subscriptions/show.html.erb"
      assert_file "app/views/settings/subscriptions/_plan.html.erb"

      assert_file "app/controllers/settings/subscriptions_controller.rb"

      assert_file "app/controllers/billing_profiles/subscriptions_controller.rb" do |content|
        assert_match(/success_url: root_url,/, content)

        assert_no_match(/success_url: main_app.root_url,/, content)
      end
    end

    test "generates sessions feature" do
      run_generator %w[sessions]

      assert_file "app/models/actor.rb"
      assert_file "app/models/user.rb"
      assert_file "app/models/user/workspace_member.rb"
      assert_file "app/models/session.rb"
      assert_file "app/models/current.rb"
      assert_file "app/models/workspace.rb"
      assert_file "app/models/role.rb"
      assert_file "app/models/member.rb"
      assert_file "app/models/member/acting.rb"
      assert_file "app/models/member/setup.rb"
      assert_file "app/models/workspace.rb"
      assert_file "app/models/workspace/members.rb"
      assert_file "app/models/workspace/setup.rb"

      assert_file "app/controllers/sessions_controller.rb"
      assert_file "app/controllers/concerns/authentication.rb"
      assert_file "config/routes.rb", /resource :session, only: %w\[new create destroy\]/

      assert_file "app/controllers/concerns/authentication.rb" do |content|
        assert_match(/redirect_to new_session_path/, content)
        assert_no_match(/kern\.new_session_path/, content)
      end
    end

    test "generates signups feature" do
      run_generator %w[signups]

      assert_file "app/models/actor.rb"
      assert_file "app/models/user.rb"
      assert_file "app/models/user/workspace_member.rb"
      assert_file "app/models/session.rb"
      assert_file "app/models/current.rb"
      assert_file "app/models/workspace.rb"
      assert_file "app/models/role.rb"
      assert_file "app/models/member.rb"
      assert_file "app/models/member/acting.rb"
      assert_file "app/models/member/setup.rb"
      assert_file "app/models/workspace.rb"
      assert_file "app/models/workspace/members.rb"
      assert_file "app/models/workspace/setup.rb"

      assert_file "config/routes.rb", /resource :signup, only: %w\[new create\]/

      assert_file "app/controllers/signups_controller.rb" do |content|
        assert_match(/redirect_to root_path/, content)

        assert_no_match(/main_app\.root_path/, content)
      end
    end

    test "generates passwords feature with mailer" do
      run_generator %w[passwords]

      assert_file "app/controllers/passwords_controller.rb"
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
      assert_file "config/routes.rb", /resource :settings, only: %w\[show\]/
      assert_file "config/routes.rb", /namespace :settings/
    end

    test "generates multiple features" do
      run_generator %w[sessions passwords]

      assert_file "app/models/user.rb"
      assert_file "app/controllers/sessions_controller.rb"
      assert_file "app/controllers/passwords_controller.rb"
    end

    test "raises error for invalid feature" do
      assert_raises(SystemExit) do
        run_generator %w[invalid_feature]
      end
    end

    test "generates sessions feature without encryption when skip_encryption is true" do
      run_generator %w[sessions --skip-encryption]

      assert_file "app/models/session.rb" do |content|
        assert_no_match(/encrypts :user_agent, :ip/, content)
      end

      assert_file "app/models/user.rb" do |content|
        assert_no_match(/encrypts :email, deterministic: true, downcase: true/, content)
      end
    end

    private

    def copy_routes_file
      routes_path = File.join(destination_root, "config/routes.rb")

      FileUtils.mkdir_p(File.dirname(routes_path))
      File.write(routes_path, "Rails.application.routes.draw do\nend\n")
    end

    def copy_routes_file_with_settings_namespace
      routes_path = File.join(destination_root, "config/routes.rb")

      FileUtils.mkdir_p(File.dirname(routes_path))
      File.write(routes_path, <<~RUBY)
        Rails.application.routes.draw do
          namespace :settings do
            resource :user, path: "account", only: %w[show update]
          end
        end
      RUBY
    end

    def copy_workspace_model
      workspace_path = File.join(destination_root, "app/models/workspace.rb")

      FileUtils.mkdir_p(File.dirname(workspace_path))
      File.write(workspace_path, <<~RUBY)
        class Workspace < ApplicationRecord
          include Sluggable
        end
      RUBY
    end
  end
end
