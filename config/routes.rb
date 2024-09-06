Rails.application.routes.draw do
  root "registers#index"
     resources :registers, except: [ :show ]
  get "/articles", to: "articles#index"
end
