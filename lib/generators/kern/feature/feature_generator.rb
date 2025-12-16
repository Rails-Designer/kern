module Kern
  class FeatureGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../../", __FILE__)

    AVAILABLE_FEATURES = %w[passwords sessions settings signups]

    argument :features, type: :array, required: true, banner: "feature feature"

    class_option :skip_encryption, type: :boolean, default: false, desc: "Skip encryption for sensitive fields"

    def copy_features
      features.each do |feature|
        verify_exists!(feature)

        case feature
        when "sessions"
          generate_sessions
        when "signups"
          generate_signups
        when "passwords"
          generate_passwords
        when "settings"
          generate_settings
        end
      end
    end

    private

    def verify_exists!(feature)
      return if AVAILABLE_FEATURES.include?(feature)

      say "Feature `#{feature}` not found. Available features: #{AVAILABLE_FEATURES.join(", ")}", :red

      exit(1)
    end

    def generate_sessions
      directory "app/models", "app/models"
      template "app/controllers/concerns/authentication.rb.tt", "app/controllers/concerns/authentication.rb"
      copy_file "app/controllers/kern/sessions_controller.rb", "app/controllers/sessions_controller.rb"
      directory "app/views/kern/sessions", "app/views/sessions"

      remove_encryption_from_models

      route "resource :session, only: %w[new create destroy]"
    end

    def generate_signups
      directory "app/models", "app/models" unless features.include?("sessions")

      template "app/controllers/kern/signups_controller.rb.tt", "app/controllers/signups_controller.rb"
      directory "app/views/kern/signups", "app/views/signups"

      remove_encryption_from_models

      route "resource :signup, only: %w[new create]"
    end

    def generate_passwords
      directory "app/views/kern/passwords", "app/views/passwords"
      copy_file "app/controllers/kern/passwords_controller.rb", "app/controllers/passwords_controller.rb"
      copy_file "app/mailers/kern/passwords_mailer.rb", "app/mailers/passwords_mailer.rb"
      template "app/views/kern/passwords_mailer/reset.text.erb.tt", "app/views/passwords_mailer/reset.text.erb"
      template "app/views/kern/passwords_mailer/reset.html.erb.tt", "app/views/passwords_mailer/reset.html.erb"

      route "resources :passwords, param: :token, only: %w[new create edit update]"
    end

    def generate_settings
      directory "app/views/kern/settings", "app/views/settings"
      copy_file "app/controllers/kern/settings_controller.rb", "app/controllers/settings_controller.rb"
      directory "app/controllers/kern/settings", "app/controllers/settings"

      route <<~RUBY
        resource :settings, only: %w[show]
        namespace :settings do
          resource :user, path: "account", only: %w[show update]
        end
      RUBY
    end

    def remove_encryption_from_models
      return unless options[:skip_encryption]

      gsub_file "app/models/session.rb", /\n  encrypts :user_agent, :ip\n/, ""
      gsub_file "app/models/user.rb", /\n  encrypts :email, deterministic: true, downcase: true\n/, ""
    end
  end
end
