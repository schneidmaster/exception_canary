require 'spec_helper'

feature 'Exception notification' do
  background do
    clear_emails
    begin
      visit '/some_action'
    rescue
      open_email('recipients@exception_canary.io')
    end
  end

  it 'notifies about an exception' do
    expect(current_email).to have_content('View or suppress exception:')
  end

  it 'provides link' do
    expect(current_email).to have_content('http://127.0.0.1:3000/exception_canary/stored_exceptions/1')
    visit 'http://127.0.0.1:3000/exception_canary/stored_exceptions/1'
    expect(page).to have_content('Stored Exception: Oh noes!')
  end
end