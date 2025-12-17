class Workspace
  module Billable
    extend ActiveSupport::Concern

    included do
      has_one :billing_profile, dependent: :destroy
    end
    delegate :subscriptions, to: :billing_profile

    def subscribed?
      return false unless billing_profile.present?

      subscriptions.exists?(status: %w[active free trialing])
    end
  end
end
