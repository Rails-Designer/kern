Rails.application.routes.draw do
  mount Kern::Engine => "/"

  root to: "dashboard#show"
end
