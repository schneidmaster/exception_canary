require 'spec_helper'

describe ExceptionCanary::Rule do
  subject { rule }

  describe '#notify?' do
    context 'when action is notify' do
      let(:rule) { create :rule, action: ExceptionCanary::Rule::ACTION_NOTIFY }
      it 'returns true' do
        expect(subject.notify?).to eq(true)
      end
    end

    context 'when action is suppress' do
      let(:rule) { create :rule, action: ExceptionCanary::Rule::ACTION_SUPPRESS }
      it 'returns false' do
        expect(subject.notify?).to eq(false)
      end
    end
  end

  describe '#suppress?' do
    context 'when action is notify' do
      let(:rule) { create :rule, action: ExceptionCanary::Rule::ACTION_NOTIFY }
      it 'returns false' do
        expect(subject.suppress?).to eq(false)
      end
    end

    context 'when action is suppress' do
      let(:rule) { create :rule, action: ExceptionCanary::Rule::ACTION_SUPPRESS }
      it 'returns true' do
        expect(subject.suppress?).to eq(true)
      end
    end
  end

  describe '#matches?' do
    let(:matching_exception) { create :stored_exception, title: 'Exact Title' }
    let(:matching_regex_exception) { create :stored_exception, title: 'Exact chars Title' }
    let(:non_matching_exception) { create :stored_exception, title: 'Inexact Title' }

    context 'when match type is exact' do
      let(:rule) { create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_EXACT, value: 'Exact Title' }

      it 'affirms matching exception' do
        expect(subject.matches?(matching_exception)).to eq(true)
      end

      it 'rejects non-matching exception' do
        expect(subject.matches?(matching_regex_exception)).to eq(false)
        expect(subject.matches?(non_matching_exception)).to eq(false)
      end
    end

    context 'when match type is regex' do
      let(:rule) { create :rule, match_type: ExceptionCanary::Rule::MATCH_TYPE_REGEX, value: 'Exact [a-z]* Title' }

      it 'affirms matching exception' do
        expect(subject.matches?(matching_regex_exception)).to eq(true)
      end

      it 'rejects non-matching exception' do
        expect(subject.matches?(non_matching_exception)).to eq(false)
      end
    end
  end
end
