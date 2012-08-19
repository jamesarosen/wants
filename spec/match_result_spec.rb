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

end
