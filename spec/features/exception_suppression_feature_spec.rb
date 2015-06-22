require 'spec_helper'

feature 'Exception suppression' do
  it 'records an exception' do
    begin
      visit '/some_action'
    rescue
      expect(ExceptionCanary::StoredException.count).to eq(1)
    end
  end

  context 'with rule exactly matching exception title' do
    let!(:rule) { create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_EXACT, value: 'Oh noes!' }

    it 'suppresses a matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).to eq(rule)
      end
    end

    it 'does not suppress a non-matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_other_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).not_to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).not_to eq(rule)
      end
    end
  end

  context 'with rule regex matching exception title' do
    let!(:rule) { create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_REGEX, value: 'Oh no[o]+es!' }

    it 'suppresses a matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_other_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).to eq(rule)
      end
    end

    it 'does not suppress a non-matching exception' do
      mail_count = ActionMailer::Base.deliveries.count
      begin
        visit '/some_action'
      rescue
        expect(ActionMailer::Base.deliveries.count).not_to eq(mail_count)
        expect(ExceptionCanary::StoredException.first.rule).not_to eq(rule)
      end
    end
  end

  context 'with no rule matching exception title' do
    it 'creates a rule' do
      begin
        visit '/some_action'
      rescue
        expect(ExceptionCanary::StoredException.first.rule).not_to eq(nil)
      end
    end
  end
end
