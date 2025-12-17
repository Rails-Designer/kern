require "test_helper"
require "generators/kern/layouts/layouts_generator"

module Kern
  class LayoutsGeneratorTest < Rails::Generators::TestCase
    tests Kern::LayoutsGenerator

    destination File.expand_path("../../dummy/tmp/generators", __dir__)

    setup :prepare_destination

    test "generates layouts" do
      run_generator

      assert_file "app/views/layouts/application.html.erb"
      assert_file "app/views/layouts/application/_navigation.html.erb"
      assert_file "app/views/layouts/auth.html.erb"

      assert_file "app/views/layouts/application.html.erb" do |content|
        assert_match(/href: root_path/, content)
        assert_no_match(/main_app\.root_path/, content)
      end
    end
  end
end
