module Kern
  module Helpers
    def bundle_command(command, env = {}, params = {})
      say_status :run, "bundle #{command}"

      # taken from railties/lib/rails/generators/bundle_helper.rb
      bundle_command = Gem.bin_path("bundler", "bundle")

      require "bundler"

      Bundler.with_original_env do
        exec_bundle_command(bundle_command, command, env, params)
      end
    end

    private

    def exec_bundle_command(bundle_command, command, env, params)
      full_command = %("#{Gem.ruby}" "#{bundle_command}" #{command})

      if options[:quiet] || params[:quiet]
        system(env, full_command, out: File::NULL)
      else
        system(env, full_command)
      end
    end
  end
end
