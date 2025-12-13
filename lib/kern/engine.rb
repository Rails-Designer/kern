module Kern
  class Engine < ::Rails::Engine
    isolate_namespace Kern

    initializer "kern.load_config", before: :load_config_initializers do
      require "kern/config"

      Kern::Config.load!
    end

    initializer "kern.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper Kern::Engine.helpers
      end
    end
  end
end
