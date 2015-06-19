require 'spec_helper'

describe ExceptionCanary, type: :feature do
  it 'records an exception' do
    begin
      visit '/some_action'
    rescue
      expect(ExceptionCanary::StoredException.count).to eq(1)
    end
  end

  context 'with rule about string equaling exception title' do
    before do
      create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_EXACT, value: 'Oh noes!'
    end

    it 'suppresses a matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).not_to eq(nil)
      end
    end

    it 'does not suppress a non-matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_other_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).not_to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).to eq(nil)
      end
    end
  end

  context 'with rule about regex match exception title' do
    before do
      create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_REGEX, value: 'Oh no[o]+es!'
    end

    it 'suppresses a matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_other_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).not_to eq(nil)
      end
    end

    it 'does not suppress a non-matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).not_to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).to eq(nil)
      end
    end
  end
end
