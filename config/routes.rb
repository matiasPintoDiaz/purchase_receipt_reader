Rails.application.routes.draw do
  # 1. Define la página de inicio de tu aplicación
  root "purchases#new"

  # 2. Crea las rutas para new, create y show de forma correcta
  #    - GET /purchases/new
  #    - POST /purchases
  #    - GET /purchases/:id
  resources :purchases, only: [ :new, :create, :show ]

  # El resto de las rutas generadas pueden quedar como están
  get "up" => "rails/health#show", as: :rails_health_check
end
