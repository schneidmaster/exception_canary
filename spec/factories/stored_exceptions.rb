FactoryGirl.define do
  factory :stored_exception, class: ExceptionCanary::StoredException do
    title 'Oh no!'
    backtrace 'some code'
    environment { { 'ENV_KEY' => 'something' } }
    variables { { var_one: 'something' } }
    klass StandardError.to_s
  end
end
