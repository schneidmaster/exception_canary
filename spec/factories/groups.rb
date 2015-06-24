FactoryGirl.define do
  factory :group, class: ExceptionCanary::Group do
    name 'Some Group'
    action ExceptionCanary::Group::ACTION_SUPPRESS
    match_type ExceptionCanary::Group::MATCH_TYPE_EXACT
    value 'Match'
    is_auto_generated true
  end
end
