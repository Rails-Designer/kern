if defined?(Stripe)
  Stripe.api_key = Config::Stripe.api_key
  Stripe.api_version = Config::Stripe.api_version
  Stripe.max_network_retries = Config::Stripe.max_network_retries
end
