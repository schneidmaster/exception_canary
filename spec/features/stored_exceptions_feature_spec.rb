require 'spec_helper'

feature 'Stored exceptions' do
  let(:rule) { create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_EXACT, value: 'An Error Occurred' }

  describe 'List view' do
    before do
      create_list(:stored_exception, 50, title: rule.value, rule: rule)
      visit '/exception_canary/stored_exceptions'
    end

    it 'lists exceptions in a table' do
      expect(page).to have_content('An Error Occurred')
    end

    it 'links to exception' do
      first(:link, rule.stored_exceptions.last.created_at).click
      expect(page).to have_content("Stored Exception: #{rule.stored_exceptions.last.title}")
    end

    it 'links to rule' do
      first(:link, rule.name).click
      expect(page).to have_content("Rule: #{rule.name}")
    end

    it 'paginates' do
      expect(page).not_to have_content('Prev')
      click_on 'Next'
      expect(page).to have_content('Prev')
      expect(page).not_to have_content('Next')
    end
  end

  describe 'Show view' do
    let(:stored_exception) { create :stored_exception, title: rule.value, rule: rule }
    before { visit "/exception_canary/stored_exceptions/#{stored_exception.id}" }

    it 'shows exception' do
      expect(page).to have_content("Stored Exception: #{stored_exception.title}")
    end
  end
end
