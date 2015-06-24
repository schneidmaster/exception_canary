require 'spec_helper'

feature 'Exception suppression' do
  it 'records an exception' do
    begin
      visit '/some_action'
    rescue
      expect(ExceptionCanary::StoredException.count).to eq(1)
    end
  end

  context 'with group exactly matching exception title' do
    let!(:group) { create :group, match_type: ExceptionCanary::Group::MATCH_TYPE_EXACT, value: '(StandardError) "Oh noes!"' }

    it 'suppresses a matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.group).to eq(group)
      end
    end

    it 'does not suppress a non-matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_other_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).not_to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.group).not_to eq(group)
      end
    end
  end

  context 'with group regex matching exception title' do
    let!(:group) { create :group, match_type: ExceptionCanary::Group::MATCH_TYPE_REGEX, value: '\(StandardError\) "Oh no[o]+es!"' }

    it 'suppresses a matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_other_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.group).to eq(group)
      end
    end

    it 'does not suppress a non-matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).not_to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.group).not_to eq(group)
      end
    end
  end

  context 'with no group matching exception title' do
    it 'creates a group' do
      begin
        visit '/some_action'
      rescue
        expect(ExceptionCanary::StoredException.first.group).not_to eq(nil)
      end
    end
  end
end
