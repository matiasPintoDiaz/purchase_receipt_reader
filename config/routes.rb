Rails.application.routes.draw do
  root "purchases#new"

  # 2. Crea las rutas para new, create y show de forma correcta
  #    - GET /purchases/new
  #    - POST /purchases
  #    - GET /purchases/:id
  resources :purchases, only: [ :new, :create, :show, :edit, :update ] do
    get :status, on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
