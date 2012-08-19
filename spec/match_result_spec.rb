require 'spec_helper'
require 'wants/match_result'

describe Wants do

  let(:accept)    { 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' }
  let(:env)       { { 'Accept' => accept } }
  let(:available) { [ :html, :xhtml, :json ] }

  subject { Wants::MatchResult.new(env, available) }

  describe 'when there are no acceptable MIME types' do
    let(:accept) { 'application/atom+xml' }

    it 'should be not_acceptable' do
      subject.should be_not_acceptable
    end

    it 'should be blank' do
      subject.should be_blank
    end

    it 'should not be present' do
      subject.should_not be_present
    end
  end

  describe 'when there are acceptable MIME types' do
    it 'should not be not_acceptable' do
      subject.should_not be_not_acceptable
    end

    it 'should not be blank' do
      subject.should_not be_blank
    end

    it 'should be present' do
      subject.should be_present
    end

    describe '[]' do
      it 'returns true for the best match' do
        subject['text/html'].should be_true
      end

      it 'returns true for the best match as an abbreviation' do
        subject[:html].should be_true
      end

      it 'returns false for non-best matches' do
        subject['application/xhtml+xml'].should be_false
      end

      it 'returns false for non-matches' do
        subject['application/atom+xml'].should be_false
      end
    end

  end

end
