ExceptionCanary::Rule.destroy_all
ExceptionCanary::StoredException.destroy_all

100.times do |i|
  title = "Error #{i} occurred"
  backtrace =
    if i == 0
      'Short backtrace'
    else
      (['Long Backtrace'] * 30).join("\n")
    end
  ExceptionCanary::StoredException.create! title: title, backtrace: backtrace, environment: { 'ENV_KEY' => 'something' }, variables: { var_one: 'something' }, klass: StandardError.to_s, rule: ExceptionCanary::Rule.create!(name: title, action: ExceptionCanary::Rule::ACTION_NOTIFY, match_type: ExceptionCanary::Rule::MATCH_TYPE_EXACT, value: title)
end

50.times do |i|
  title = "Error #{i + 100} occurred"
  backtrace = (['Long Backtrace'] * 30).join("\n")
  rule = ExceptionCanary::Rule.first
  ExceptionCanary::StoredException.create! title: title, backtrace: backtrace, environment: { 'ENV_KEY' => 'something' }, variables: { var_one: 'something' }, klass: StandardError.to_s, rule: rule
end