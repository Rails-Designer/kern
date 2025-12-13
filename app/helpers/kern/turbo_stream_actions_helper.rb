module Kern
  module TurboStreamActionsHelper
    def notify(message, type: "notice")
      append("flash") { @view_context.render "components/flash/message", type: type, message: message }
    end
    alias_method :notify_with, :notify
  end
end

Turbo::Streams::TagBuilder.prepend(Kern::TurboStreamActionsHelper)
