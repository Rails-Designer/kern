# Example:
#   <%= component "card", locals: { title: "My Card" } do %>
#     <p>This is the card content.</p>
#   <% end %>
#
# This will render `app/views/components/_card.html.erb` and pass the block's
# content to the `yield` statement within the card partial.
#
module Kern
  module ComponentHelper
    def component(name, locals = {}, &block)
      render(layout: "components/#{name}", locals: locals) { block_given? ? capture(&block) : "" }
    end
  end
end
