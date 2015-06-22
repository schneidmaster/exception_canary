require 'spec_helper'

feature 'Rules' do
  describe 'List view' do
    before do
      create_list(:rule, 50, name: 'A Rule')
      visit '/exception_canary/rules'
    end

    it 'lists rules in a table' do
      expect(page).to have_content('A Rule')
    end

    it 'links to rule' do
      first(:link, 'A Rule').click
      expect(page).to have_content('Rule: A Rule')
    end

    it 'paginates' do
      expect(page).not_to have_content('Prev')
      click_on 'Next'
      expect(page).to have_content('Prev')
      expect(page).not_to have_content('Next')
    end
  end

  describe 'Show view' do
    let(:rule) { create :rule, name: 'A Rule', value: 'An Error Occurred' }

    before do
      create_list(:stored_exception, 50, title: rule.value, rule: rule)
      visit "/exception_canary/rules/#{rule.id}"
    end

    it 'shows rule' do
      expect(page).to have_content("Rule: #{rule.name}")
    end

    it 'lists exceptions in a table' do
      expect(page).to have_content('An Error Occurred')
    end

    it 'links to exception' do
      first(:link, rule.stored_exceptions.last.created_at).click
      expect(page).to have_content("Stored Exception: #{rule.stored_exceptions.last.title}")
    end

    it 'paginates stored exceptions' do
      expect(page).not_to have_content('Prev')
      click_on 'Next'
      expect(page).to have_content('Prev')
      expect(page).not_to have_content('Next')
    end
  end
end