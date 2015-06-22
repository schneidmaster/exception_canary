ExceptionCanary::Dashboard.routes.draw do
  root to: 'stored_exceptions#index'

  resources :rules do
    get 'page/:page', action: :index, on: :collection
    get ':id/page/:page', action: :show, on: :collection
  end

  resources :stored_exceptions, only: [:index, :show] do
    get 'page/:page', action: :index, on: :collection
  end
end
