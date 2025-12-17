module Stripe
  class CustomerSubscriptionDeleted < Base
    def process!
      cancel_subscription_items_for billing_profile

      @webhook_event.processed!
    end

    private

    def cancel_subscription_items_for(billing_profile)
      billing_profile.subscriptions.where(subscription_id: payload["data"]["object"]["id"]).each do |subscription|
        subscription.update!(
          status: "canceled",
          cancel_at: Time.at(payload["data"]["object"]["canceled_at"] || payload["data"]["object"]["ended_at"] || Time.current.to_i)
        )
      end
    end
  end
end
