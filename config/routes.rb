Kern::Engine.routes.draw do
  resource :settings, only: %w[show]
  namespace :settings do
    resource :user, path: "account", only: %w[show update]

    resource :subscriptions, only: %w[show]
  end

  resource :subscriptions, module: :billing_profiles, only: %w[create edit]

  resource :signup, only: %w[new create]

  resource :session, only: %w[new create destroy]
  resources :passwords, param: :token, only: %w[new create edit update]

  root to: "pages#welcome" unless Rails.application.routes.named_routes.key?(:root)
end
