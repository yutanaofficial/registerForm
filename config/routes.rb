Rails.application.routes.draw do
  root "registers#index"
     resources :registers
  get "/articles", to: "articles#index"
end
