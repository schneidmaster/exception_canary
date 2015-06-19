ExceptionCanary::Dashboard.routes.draw do
  resources :rules
  resources :stored_exceptions, only: [:index, :show]
end
