Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchant_search#show'
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resource :merchant, module: 'items', only: [:show]
      end
      resources :merchants, only: [:index, :show] do
      # namespace :merchants do
      #   get '/:id/items', to: 'items#index'
      # end
        resources :items, module: 'merchants'
      end
    end
  end
end
