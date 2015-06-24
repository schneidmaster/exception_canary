FactoryGirl.define do
  factory :group, class: ExceptionCanary::Group do
    name 'Some Group'
    action ExceptionCanary::Group::ACTION_NOTIFY
    match_type ExceptionCanary::Group::MATCH_TYPE_EXACT
    value 'Match'
    note 'Some reasons'
    is_auto_generated true
  end
end
