module Kern
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../../app/views", __FILE__)

    AVAILABLE_VIEWS = %w[layouts passwords sessions settings signups]

    argument :views, type: :array, default: [], banner: "view view", desc: "Select specific view directories to generate (#{AVAILABLE_VIEWS.join(", ")}). Leave empty for all."

    def copy_views
      views_to_generate.map(&:inquiry).each do |view|
        verify_view_exists!(view)

        if view.layouts?
          generate_layouts
        else
          directory "kern/#{view}", "app/views/#{view}", recursive: true
        end
      end
    end

    private

    def views_to_generate
      views.any? ? views : AVAILABLE_VIEWS
    end

    def verify_view_exists!(view)
      return if AVAILABLE_VIEWS.include?(view)

      say "View `#{view}` not found. Available views: #{AVAILABLE_VIEWS.join(", ")}", :red

      exit(1)
    end

    def generate_layouts
      template "layouts/kern/application.html.erb.tt", "app/views/layouts/application.html.erb"
      copy_file "layouts/kern/application/_navigation.html.erb", "app/views/layouts/application/_navigation.html.erb"

      copy_file "layouts/kern/auth.html.erb", "app/views/layouts/auth.html.erb"
    end
  end
end
