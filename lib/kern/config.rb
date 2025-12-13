# frozen_string_literal: true

module Kern
  module Config
    module_function

    def load!
      configurations_path = Rails.root.join("config", "configurations")

      return unless File.directory?(configurations_path)

      Dir.glob(configurations_path.join("*.yml")).each do |path|
        file_name = File.basename(path, ".yml")

        ::Config.const_set(
          file_name.camelize,
          Rails.application.config_for("configurations/#{file_name}")
        )
      end
    end
  end
end

module Config
end
