module Stripe
  class CheckoutSessionCompleted < Base
    def process!
      billing_profile = create_billing_profile_for workspace

      attach_subscription_items_to billing_profile

      @webhook_event.processed!
    end

    private

    def create_billing_profile_for(workspace)
      BillingProfile.where(
        workspace: workspace,
        external_id: payload["data"]["object"]["customer"]
      ).first_or_create
    end

    def attach_subscription_items_to(billing_profile)
      subscription_resource["items"]["data"].each do |item|
        subscription = BillingProfile::Subscription.find_or_initialize_by(
          billing_profile: billing_profile,
          subscription_item_id: item["id"]
        )

        subscription.update!(
          subscription_id: subscription_resource["id"],
          status: subscription_resource["status"],
          cancel_at: subscription_resource["cancel_at"] ? Time.at(subscription_resource["cancel_at"]) : nil,
          current_period_end_at: subscription_resource["current_period_end"] ? Time.at(subscription_resource["current_period_end"]) : nil,
          quantity: item["quantity"],
          product_id: item["price"]["product"],
          price_id: item["price"]["id"],
          interval: item["price"]["recurring"]["interval"]
        )

        workspace.add_access(item["price"]["product"])
      end
    end

    def workspace
      @workspace ||= Workspace.sluggable.find(payload["data"]["object"]["client_reference_id"])
    end
  end
end
