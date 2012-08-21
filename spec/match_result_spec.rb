require 'spec_helper'
require 'wants/match_result'

describe Wants do

  let(:accept)    { 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' }
  let(:available) { [ :html, :xhtml, :json ] }

  subject { Wants::MatchResult.new(accept, available) }

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

    describe 'any' do
      it 'acts like a non-best-match MIME block method' do
        evaluated = 0

        subject.any { evaluated += 1; 'not acceptable' }.should == nil
        evaluated.should == 0
      end

      it "doesn't shadow previous results" do
        subject.not_acceptable { 'not acceptable' }
        subject.any  { 'any' }.should == 'not acceptable'
      end
    end

    describe 'not_acceptable' do
      it 'acts like a best-match MIME block method' do
        evaluated = 0

        subject.not_acceptable { evaluated += 1; 'not_acceptable' }.should == 'not_acceptable'
        evaluated.should == 1

        subject.json { evaluated += 1; 'json' }.should == 'not_acceptable'
        evaluated.should == 1
      end
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

    describe '#respond_to?' do
      it 'returns true for MIME-like query methods' do
        subject.respond_to?(:html?).should be_true
      end

      it 'returns true for MIME block methods' do
        subject.respond_to?(:json).should be_true
      end
    end

    describe 'MIME query methods' do
      it 'returns true for the best match as an abbreviation' do
        subject.should be_html
      end

      it 'returns false for non-best matches' do
        subject.should_not be_xhtml
      end

      it 'returns false for non-matches' do
        subject.should_not be_atom
      end

      it 'throws an exception if passed arguments' do
        expect {
          subject.html? :anything
        }.to raise_error(ArgumentError)
      end
    end

    describe 'MIME block methods' do
      it 'evaluates the block and returns its result only if the best match' do
        evaluated = 0

        subject.atom { evaluated += 1; 'atom' }.should be_nil
        evaluated.should == 0

        subject.html { evaluated += 1; 'html' }.should == 'html'
        evaluated.should == 1

        subject.json { evaluated += 1; 'json' }.should == 'html'
        evaluated.should == 1
      end
    end

    describe 'any' do
      it 'acts like a best-match MIME block method' do
        evaluated = 0

        subject.any { evaluated += 1; 'any' }.should == 'any'
        evaluated.should == 1

        subject.json { evaluated += 1; 'json' }.should == 'any'
        evaluated.should == 1
      end
    end

    describe 'not_acceptable' do
      it 'acts like a non-best-match MIME block method' do
        evaluated = 0

        subject.not_acceptable { evaluated += 1; 'not acceptable' }.should == nil
        evaluated.should == 0
      end

      it "doesn't shadow previous results" do
        subject.html { 'html' }
        subject.not_acceptable { 'not acceptable' }.should == 'html'
      end
    end

  end

end
