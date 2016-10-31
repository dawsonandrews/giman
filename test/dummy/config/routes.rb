Rails.application.routes.draw do
  resources :products
  resources :users
  mount Giman::Engine => '/uploads'
end
