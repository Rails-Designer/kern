# frozen_string_literal: true

require "rails/generators/base"

module Rails
  module Generators
    class ConfigGenerator < Rails::Generators::NamedBase
      desc <<~DESC
        Generates a configuration YAML file with environment variable mappings.

        Example:
            bin/rails generate config bot user_agent api_key

        This will create:
            config/configurations/bot.yml

        With content:
            key1: <%= ENV.fetch("BOT_USER_AGENT", "fallback_value") %>
            key2: <%= ENV.fetch("BOT_API_KEY", "fallback_value") %>
      DESC

      argument :keys, type: :array, default: [], banner: "key1 key2 key3"

      def create_config_file
        create_file "config/configurations/#{file_name}.yml", config_content
      end

      private

      def config_content
        "".tap do |content|
          content << "# config/configurations/#{file_name}.yml\n"

          keys.each do |key|
            env_var = "#{file_name.upcase}_#{key.upcase}"

            content << "#{key}: <%= ENV.fetch(\"#{env_var}\", \"fallback_value\") %>\n"
          end
        end
      end
    end
  end
end
