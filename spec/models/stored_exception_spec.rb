require 'spec_helper'

describe ExceptionCanary::StoredException do
  subject { stored_exception }

  describe '#backtrace_summary' do
    context 'backtrace is <300 characters' do
      let(:stored_exception) { create :stored_exception, backtrace: 'Short Backtrace' }

      it 'shows whole backtrace' do
        expect(subject.backtrace_summary).to eq('Short Backtrace')
      end
    end

    context 'backtrace is >300 characters' do
      let(:stored_exception) { create :stored_exception, backtrace: (['Long Backtrace'] * 30).join("\n") }

      it 'truncates backtrace' do
        expect(subject.backtrace_summary.length).to eq(300)
        expect(subject.backtrace_summary[297...300]).to eq('...')
      end
    end
  end
end
