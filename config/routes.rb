Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/api/v1/merchants/find', to: 'api/v1/merchants#find'
  # get '/api/v1/merchants/most_items', to: 'api/v1/merchants#most_items'
  # get '/api/v1/items/find_all', to: 'api/v1/items#find_all'

  namespace :api do
    namespace :v1 do
      namespace :revenue do
        resources :merchants, only: [:index, :show]
        resources :items, only: [:index]
      end
      resources :merchants, only: [:index, :show] do
        collection do
          get '/find', to: 'merchants#find'
          get '/most_items', to: 'merchants#most_items'
        end
        resources :items, only: [:index], controller: 'merchants/items'
      end
      resources :items do
        collection do
          get '/find_all', to: 'items#find_all'
        end
        resources :merchant, only: [:index], controller: 'items/merchants'
      end
    end
  end

end
