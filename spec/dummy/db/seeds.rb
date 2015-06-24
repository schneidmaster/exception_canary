ExceptionCanary::Group.destroy_all
ExceptionCanary::StoredException.destroy_all

100.times do |i|
  title = "Error #{i} occurred"
  backtrace =
    if i == 0
      'Short backtrace'
    else
      (['Long Backtrace'] * 30).join("\n")
    end
  ExceptionCanary::StoredException.create! title: title, backtrace: backtrace, environment: { 'ENV_KEY' => 'something' }, variables: { var_one: 'something' }, klass: StandardError.to_s, group: ExceptionCanary::Group.create!(name: title, action: ExceptionCanary::Group::ACTION_NOTIFY, match_type: ExceptionCanary::Group::MATCH_TYPE_EXACT, value: title)
end

50.times do |i|
  title = "Error #{i + 100} occurred"
  backtrace = (['Long Backtrace'] * 30).join("\n")
  group = ExceptionCanary::Group.first
  ExceptionCanary::StoredException.create! title: title, backtrace: backtrace, environment: { 'ENV_KEY' => 'something' }, variables: { var_one: 'something' }, klass: StandardError.to_s, group: group
end