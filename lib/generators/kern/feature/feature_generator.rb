module Kern
  class FeatureGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../../", __FILE__)

    AVAILABLE_FEATURES = %w[billing passwords sessions settings signups]

    argument :features, type: :array, required: true, banner: "feature feature"

    class_option :skip_encryption, type: :boolean, default: false, desc: "Skip encryption for sensitive fields"

    def copy_features
      features.each do |feature|
        verify_exists!(feature)

        case feature
        when "billing"
          generate_billing
        when "passwords"
          generate_passwords
        when "sessions"
          generate_sessions
        when "settings"
          generate_settings
        when "signups"
          generate_signups
        end
      end
    end

    private

    def verify_exists!(feature)
      return if AVAILABLE_FEATURES.include?(feature)

      say "Feature `#{feature}` not found. Available features: #{AVAILABLE_FEATURES.join(", ")}", :red

      exit(1)
    end

    def generate_billing
      template "config/initializers/stripe.rb.tt", "config/initializers/stripe.rb"

      [
        "billing_profile.rb",
        "billing_profile/subscription.rb",
        "workspace/billable.rb"
      ].each { copy_file "app/models/#{it}", "app/models/#{it}" }

      inject_into_file "app/models/workspace.rb", "  include Billable\n\n", after: "include Sluggable\n"

      route "resource :subscriptions, module: :billing_profiles, only: %w[create edit]"
      inject_into_file "config/routes.rb", "    resource :subscriptions, only: %w[show]\n", after: "namespace :settings do\n"

      copy_file "app/views/kern/settings/subscriptions/show.html.erb", "app/views/settings/subscriptions/show.html.erb"
      copy_file "app/views/kern/settings/subscriptions/_plan.html.erb", "app/views/settings/subscriptions/_plan.html.erb"

      copy_file "app/controllers/kern/settings/subscriptions_controller.rb", "app/controllers/settings/subscriptions_controller.rb"
      template "app/controllers/kern/billing_profiles/subscriptions_controller.rb.tt", "app/controllers/billing_profiles/subscriptions_controller.rb"
    end

    def generate_passwords
      copy_file "app/controllers/kern/passwords_controller.rb", "app/controllers/passwords_controller.rb"
      copy_file "app/mailers/kern/passwords_mailer.rb", "app/mailers/passwords_mailer.rb"

      template "app/views/kern/passwords_mailer/reset.text.erb.tt", "app/views/passwords_mailer/reset.text.erb"
      template "app/views/kern/passwords_mailer/reset.html.erb.tt", "app/views/passwords_mailer/reset.html.erb"

      copy_file "app/views/kern/passwords/new.html.erb", "app/views/passwords/new.html.erb"
      copy_file "app/views/kern/passwords/edit.html.erb", "app/views/passwords/edit.html.erb"

      route "resources :passwords, param: :token, only: %w[new create edit update]"
    end

    def generate_sessions
      AUTHENTICATION_MODELS.each { copy_file "app/models/#{it}", "app/models/#{it}" }

      template "app/controllers/concerns/authentication.rb.tt", "app/controllers/concerns/authentication.rb"
      copy_file "app/controllers/kern/sessions_controller.rb", "app/controllers/sessions_controller.rb"

      copy_file "app/views/kern/sessions/new.html.erb", "app/views/sessions/new.html.erb"

      remove_encryption_from_models

      route "resource :session, only: %w[new create destroy]"
    end

    def generate_settings
      copy_file "app/controllers/kern/settings_controller.rb", "app/controllers/settings_controller.rb"
      directory "app/controllers/kern/settings", "app/controllers/settings"

      copy_file "app/views/kern/settings/show.html.erb", "app/views/settings/show.html.erb"
      copy_file "app/views/kern/settings/_cards.html.erb", "app/views/settings/_cards.html.erb"
      copy_file "app/views/kern/settings/users/show.html.erb", "app/views/settings/users/show.html.erb"

      route <<~RUBY
        resource :settings, only: %w[show]
        namespace :settings do
          resource :user, path: "account", only: %w[show update]
        end
      RUBY
    end

    def generate_signups
      AUTHENTICATION_MODELS.each { copy_file "app/models/#{it}", "app/models/#{it}" } unless features.include?("sessions")

      template "app/controllers/kern/signups_controller.rb.tt", "app/controllers/signups_controller.rb"

      copy_file "app/views/kern/signups/new.html.erb", "app/views/signups/new.html.erb"

      remove_encryption_from_models

      route "resource :signup, only: %w[new create]"
    end

    def remove_encryption_from_models
      return unless options[:skip_encryption]

      gsub_file "app/models/session.rb", /\n  encrypts :user_agent, :ip\n/, ""
      gsub_file "app/models/user.rb", /\n  encrypts :email, deterministic: true, downcase: true\n/, ""
    end

    AUTHENTICATION_MODELS = [
      "actor.rb",
      "application_form.rb",
      "current.rb",
      "member.rb",
      "role.rb",
      "session.rb",
      "signup.rb",
      "user.rb",
      "workspace.rb",
      "member/acting.rb",
      "member/setup.rb",
      "user/workspace_member.rb",
      "workspace/members.rb",
      "workspace/setup.rb"
    ]
  end
end
