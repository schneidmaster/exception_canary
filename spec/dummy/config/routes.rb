Rails.application.routes.draw do
  get '/', to: redirect('/exception_canary')
  get :some_action, to: 'some#action'
  get :some_other_action, to: 'some#other_action'
  mount ExceptionCanary::Dashboard => '/exception_canary'
end
