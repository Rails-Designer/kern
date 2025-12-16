require "generators/kern/helpers"

module Kern
  class InstallGenerator < Rails::Generators::Base
    include Helpers

    source_root File.expand_path("templates", __dir__)

    class_option :skip_migrations, type: :boolean, default: false

    def add_gems
      gem "stripe"
      gem "rails_icons"
    end

    def enable_bcrypt
      if File.read(File.expand_path("Gemfile", destination_root)).include?('gem "bcrypt"')
        uncomment_lines "Gemfile", /gem "bcrypt"/

        bundle_command("install --quiet")
      else
        bundle_command("add bcrypt", {}, quiet: true)
      end
    end

    def copy_migrations
      return if options[:skip_migrations]

      rails_command "railties:install:migrations FROM=kern", inline: true
    end

    def inject_authentication
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
        "  include Authentication\n"
      end
    end

    def inject_kern_layout
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
        "  layout \"kern/application\"\n"
      end
    end

    def copy_configurations
      template "configurations/urls.yml", "config/configurations/urls.yml"
      template "configurations/stripe.yml", "config/configurations/stripe.yml"
      template "configurations/plans.yml", "config/configurations/plans.yml"

      template "configurations/README.md", "config/configurations/README.md"
    end

    def mount_engine
      route 'mount Kern::Engine => "/"'
    end

    def post_install_message
      readme "POST_INSTALL" if behavior == :invoke
    end
  end
end
