module Kern
  class LayoutsGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../../app/views", __FILE__)

    def copy_layouts
      template "layouts/kern/application.html.erb.tt", "app/views/layouts/application.html.erb"
      copy_file "layouts/kern/application/_navigation.html.erb", "app/views/layouts/application/_navigation.html.erb"

      template "layouts/kern/auth.html.erb.tt", "app/views/layouts/auth.html.erb"
    end
  end
end
