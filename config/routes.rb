Rails.application.routes.draw do
  root "registers#new"
     resources :registers, except: [ :show ]
  get "/articles", to: "articles#index"

  # get "/registers/export_csv", to: "registers#export_csv", as: "export_registers_csv"
end
