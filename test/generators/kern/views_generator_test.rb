require "test_helper"
require "generators/kern/views/views_generator"

module Kern
  class ViewsGeneratorTest < Rails::Generators::TestCase
    tests Kern::ViewsGenerator

    destination File.expand_path("../../dummy/tmp/generators", __dir__)

    setup :prepare_destination

    test "generates all views when no arguments provided" do
      run_generator

      assert_file "app/views/passwords"
      assert_file "app/views/sessions"
      assert_file "app/views/settings"
      assert_file "app/views/signups"
      assert_file "app/views/layouts"
    end

    test "generates specific view when provided" do
      run_generator %w[sessions]

      assert_file "app/views/sessions"

      assert_no_file "app/views/passwords"
      assert_no_file "app/views/settings"
      assert_no_file "app/views/signups"
    end

    test "generates multiple specific views" do
      run_generator %w[sessions passwords]

      assert_file "app/views/sessions/new.html.erb"
      assert_file "app/views/passwords"

      assert_no_file "app/views/settings"
      assert_no_file "app/views/signups"
      assert_no_file "app/views/layouts"
    end

    test "generates specific layout when provided" do
      run_generator %w[layouts]

      assert_file "app/views/layouts/application.html.erb"
      assert_file "app/views/layouts/application/_navigation.html.erb"
      assert_file "app/views/layouts/auth.html.erb"

      assert_no_file "app/views/passwords"
      assert_no_file "app/views/settings"
      assert_no_file "app/views/signups"

      assert_file "app/views/layouts/application.html.erb" do |content|
        assert_match(/href: root_path/, content)
        assert_no_match(/main_app\.root_path/, content)
      end
    end

    test "raises error for invalid view" do
      assert_raises(SystemExit) do
        run_generator %w[invalid_view]
      end
    end
  end
end
