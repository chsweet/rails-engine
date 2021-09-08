Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'api/v1/merchants/find', to: 'api/v1/merchants#find'
  get 'api/v1/items/find_all', to: 'api/v1/items#find_all'

  namespace :api do
    namespace :v1 do
      namespace :revenue do
        resources :merchants, only: [:index]
        resources :items
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      resources :items do
        resources :merchant, only: [:index], controller: 'items/merchants'
      end
    end
  end

end
