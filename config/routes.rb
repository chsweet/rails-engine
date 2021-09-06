Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'api/v1/merchants/find', to: 'api/v1/merchants#find'

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      resources :items do
        resources :merchant, only: [:index], controller: 'items/merchants'
      end
    end
  end

end
