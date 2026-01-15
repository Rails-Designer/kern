module Stripe
  class Base < (defined?(Fuik::Event) ? Fuik::Event : Object)
    def self.verify!(request)
      secret = Rails.application.credentials.dig(:stripe, :signing_secret)
      signature = request.headers["Stripe-Signature"]

      Stripe::Webhook.construct_event(
        request.raw_post,
        signature,
        secret
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError => error
      raise Fuik::InvalidSignature, error.message
    end

    private

    def subscription_resource
      @subscription_resource ||= ::Stripe::Subscription.retrieve(
        id: payload["data"]["object"]["subscription"],
        expand: ["items.data.price"]
      )
    end

    def workspace = billing_profile.workspace

    def billing_profile
      BillingProfile.find_by!(external_id: payload["data"]["object"]["customer"])
    end
  end
end
