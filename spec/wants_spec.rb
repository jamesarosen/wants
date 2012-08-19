require 'spec_helper'
require 'wants'

describe Wants do

  describe '.new' do
    it 'delegates to Wants::MatchResult.new' do
      env = Object.new
      mime_types = [ :html, :json ]
      result = Object.new
      Wants::MatchResult.should_receive(:new).with(env, mime_types) { result }
      Wants.new(env, mime_types).should == result
    end
  end

  describe '.mime_lookup_table' do
    subject { Wants.mime_lookup_table }

    before do
      require 'rack/mime'
      Wants.instance_eval do
        @mime_lookup_table = nil
      end
    end

    describe 'when Rack::Mime::MIME_TYPES is available' do
      it 'defaults to that' do
        subject.should == Rack::Mime::MIME_TYPES
      end
    end

    describe 'when Rack::Mime::MIME_TYPES is unavailable' do
      before do
        Wants.stub(:require) { raise LoadError.new('Rack unavailable') }
      end

      it 'defaults to an empty Hash' do
        subject.should == {}
      end
    end

    it 'can be set' do
      table = Object.new
      Wants.mime_lookup_table = table
      subject.should == table
    end

  end

end
