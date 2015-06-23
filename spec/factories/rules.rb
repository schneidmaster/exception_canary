FactoryGirl.define do
  factory :rule, class: ExceptionCanary::Rule do
    name 'Some rule'
    action ExceptionCanary::Rule::ACTION_SUPPRESS
    match_type ExceptionCanary::Rule::MATCH_TYPE_EXACT
    value 'Match'
    is_active true
    is_auto_generated true
  end
end
