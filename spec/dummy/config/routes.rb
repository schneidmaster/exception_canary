Rails.application.routes.draw do
  get :some_action, to: 'some#action'
  get :some_other_action, to: 'some#other_action'
  get :some_name_action, to: 'some#name_action'
  get :some_no_method_action, to: 'some#no_method_action'
  mount ExceptionCanary::Dashboard => '/exception_canary'
end
