module Kern
  class BillingProfiles::SubscriptionsController < ApplicationController
    def create
      session = Stripe::Checkout::Session.create({
        success_url: main_app.root_url,
        cancel_url: settings_subscriptions_url,
        client_reference_id: Current.workspace.slug,
        customer_email: Current.user.email_address,
        mode: "subscription",

        subscription_data: {
          trial_period_days: Config::Stripe.trial_period_days
        },

        line_items: [{
          quantity: 1,
          price: price_id
        }]
      })

      redirect_to session.url, status: 303, allow_other_host: true
    end

    def edit
      session = Stripe::BillingPortal::Session.create({
        customer: Current.workspace.billing_profile.external_id,
        return_url: main_app.root_url
      })

      redirect_to session.url, status: 303, allow_other_host: true
    end

    private

    def price_id = params[:price_id] || Config::Stripe.default_price_id
  end
end
