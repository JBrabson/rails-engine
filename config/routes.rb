Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:id/items', to: 'items#index'
      resources :merchants, only: [:index, :show]
      end
    end
  end
end
