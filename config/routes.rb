ExceptionCanary::Dashboard.routes.draw do
  get '/', to: 'stored_exceptions#index'

  resources :rules
  resources :stored_exceptions, only: [:index, :show]
end
