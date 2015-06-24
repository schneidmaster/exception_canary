require 'spec_helper'

feature 'Groups' do
  describe 'List view' do
    before do
      create_list(:group, 50, name: 'A Group')
      visit '/exception_canary/groups'
    end

    it 'lists groups in a table' do
      expect(page).to have_content('A Group')
    end

    it 'links to group' do
      first(:link, 'A Group').click
      expect(page).to have_content('A Group')
    end

    it 'paginates' do
      expect(page).not_to have_content('Prev')
      click_on 'Next'
      expect(page).to have_content('Prev')
      expect(page).not_to have_content('Next')
    end
  end

  describe 'Show view' do
    let(:group) { create :group, name: 'A Group', value: 'An Error Occurred' }

    before do
      create_list(:stored_exception, 100, title: group.value, group: group)
      visit "/exception_canary/groups/#{group.id}"
    end

    it 'shows group' do
      expect(page).to have_content(group.name)
    end

    it 'lists exceptions in a table' do
      expect(page).to have_content('An Error Occurred')
    end

    it 'links to exception' do
      first(:link, group.stored_exceptions.last.created_at.strftime('%Y-%m-%d %H:%M:%S')).click
      expect(page).to have_content(group.stored_exceptions.last.title)
    end

    it 'does not link to group' do
      within 'table:last' do
        expect(page).not_to have_content(group.name)
      end
    end

    it 'paginates stored exceptions' do
      expect(page).not_to have_content('Prev')
      click_on 'Next'
      expect(page).to have_content('Prev')
      expect(page).not_to have_content('Next')
    end
  end

  describe 'Updates group' do
    let!(:group) { create :group, name: 'A Group', value: 'An Error Occurred' }
    let!(:stored_exception) { create :stored_exception, title: group.value, group: group }
    let!(:nonmatching_stored_exception) { create :stored_exception, title: 'A Misc Error Occurred' }

    before { visit "/exception_canary/groups/#{group.id}/edit" }

    context 'invalid fields' do
      it 'shows errors' do
        fill_in 'Name', with: ''
        fill_in 'Value', with: ''
        click_on 'Update Group'
        expect(page).to have_content('Name can\'t be blank')
        expect(page).to have_content('Value can\'t be blank')
      end
    end

    context 'valid fields' do
      before do
        fill_in 'Name', with: 'The New Group'
        fill_in 'Value', with: 'A Misc Error Occurred'
        click_on 'Update Group'
      end

      it 'updates group and reclassifies exceptions' do
        expect(page).to have_content('Updated group and reclassified 2 exceptions.')
        expect(page).to have_content('The New Group')
        within 'table:last' do
          expect(page).not_to have_content('An Error Occurred')
          expect(page).to have_content('A Misc Error Occurred')
        end
      end
    end

    context 'with buttons on group page' do
      before { visit "/exception_canary/groups/#{group.id}" }

      it 'updates action' do
        click_on 'Switch to Notify'
        expect(page).to have_content('Updated group and reclassified 0 exceptions.')
        expect(page).to have_content('Switch to Suppress')
        expect(page).not_to have_content('Switch to Notify')
      end
    end

    context 'with buttons on exception page' do
      before { visit "/exception_canary/stored_exceptions/#{stored_exception.id}" }

      it 'updates action' do
        click_on 'Switch to Notify'
        expect(page).to have_content('Updated group and reclassified 0 exceptions.')
        expect(page).to have_content('Switch to Suppress')
        expect(page).not_to have_content('Switch to Notify')
      end
    end
  end

  describe 'Deletes group' do
    let!(:group) { create :group, name: 'An Outdated group' }
    let!(:stored_exception) { create :stored_exception, title: group.value, group: group }

    before { visit "/exception_canary/groups/#{group.id}" }

    it 'deletes group and reclassifies exceptions' do
      click_on 'Delete'
      expect(page).to have_content('Deleted group.')
      expect(page).not_to have_content('An Outdated group')
      click_on 'Exceptions'
      click_on stored_exception.created_at.strftime('%Y-%m-%d %H:%M:%S')
      expect(page).not_to have_content('An Outdated group')
    end
  end
end
