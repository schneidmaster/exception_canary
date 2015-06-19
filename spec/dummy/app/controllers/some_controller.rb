class SomeController < ApplicationController
  def action
    @var_one = 'test'
    ENV['ENV_KEY'] = 'test'
    fail StandardError, 'Oh noes!'
  end

  def other_action
    @var_one = 'test_two'
    ENV['ENV_KEY'] = 'test_two'
    fail StandardError, 'Oh noooes!'
  end
end
