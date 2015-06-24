require 'spec_helper'

feature 'Stored exceptions' do
  let(:group) { create :group, match_type: ExceptionCanary::Group::MATCH_TYPE_EXACT, value: 'An Error Occurred' }

  describe 'List view' do
    let!(:exception) { create :stored_exception, title: 'Special Exception' }

    before do
      create_list(:stored_exception, 99, title: group.value, group: group)
      visit '/exception_canary/stored_exceptions'
    end

    it 'lists exceptions in a table' do
      expect(page).to have_content('An Error Occurred')
    end

    it 'links to exception' do
      first(:link, group.stored_exceptions.last.created_at.strftime('%Y-%m-%d %H:%M:%S')).click
      expect(page).to have_content(group.stored_exceptions.last.title)
    end

    it 'links to group' do
      first(:link, group.name).click
      expect(page).to have_content(group.name)
    end

    it 'paginates' do
      expect(page).not_to have_content('Prev')
      click_on 'Next'
      expect(page).to have_content('Prev')
      expect(page).not_to have_content('Next')
    end

    context 'when searching' do
      before do
        fill_in 'term', with: 'Special Exception'
        click_on 'Search'
      end

      it 'searches for the exception' do
        expect(page).to have_content('Special Exception')
        expect(page).not_to have_content('An Error Occurred')
      end

      it 'clears search' do
        click_on 'Clear'
        expect(page).not_to have_content('Special Exception')
        expect(page).to have_content('An Error Occurred')
      end
    end
  end

  describe 'Show view' do
    let(:stored_exception) { create :stored_exception, title: group.value, group: group }
    before { visit "/exception_canary/stored_exceptions/#{stored_exception.id}" }

    it 'shows exception' do
      expect(page).to have_content(stored_exception.title)
    end
  end
end
