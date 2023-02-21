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
end
