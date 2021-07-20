Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
      # namespace :merchants do
      #   get '/:id/items', to: 'items#index'
      # end
        resources :items, module: 'merchants'
      end
    end
  end
end
