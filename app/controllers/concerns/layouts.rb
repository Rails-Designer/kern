module Layouts
  extend ActiveSupport::Concern

  class_methods do
    def define_layout(layout_name, namespace: "kern")
      layout -> { resolve(layout_name, namespace) }
    end
  end

  private

  def resolve(layout_name, namespace)
    layout_name = layout_name.to_s

    return layout_name if lookup_context.exists?(layout_name, ['layouts'])

    namespaced = "#{namespace}/#{layout_name}"
    return namespaced if lookup_context.exists?(namespaced, ['layouts'])

    false
  end
end
