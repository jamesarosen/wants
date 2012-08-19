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

end
