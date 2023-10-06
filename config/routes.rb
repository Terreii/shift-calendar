Rails.application.routes.draw do
  scope '/admin' do
    resources :holidays
    resources :school_breaks
  end
  resources :calendar, only: [:index, :show] do
    member do
      get ":year", to: "calendar#year", as: :year, constraints: { year: /\d{4}/ }
      get ":year/:month", to: "calendar#show", as: :month, constraints: { year: /\d{4}/, month: /\d{1,2}/ }
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
