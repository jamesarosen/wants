require 'spec_helper'
require 'wants/validate_accepts_middleware'

describe Wants do

  let(:upstream) { double('App') }
  let(:accept)   { nil }
  let(:env)      { { 'HTTP_ACCEPT' => accept } }

  subject { Wants::ValidateAcceptsMiddleware.new(upstream, :mime_types => [ :html, :json ]) }

  describe 'when there is an acceptable MIME type' do
    let(:accept)   { 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.1' }

    it 'passes the request upstream' do
      upstream.should_receive(:call).with(env)
      subject.call(env)
    end

    it 'returns the upstream response' do
      result = double('Result')
      upstream.stub(:call) { result }
      subject.call(env).should == result
    end
  end

  describe 'when there is no acceptable MIME type' do
    let(:accept)   { 'application/atom+xml' }

    it "doesn't pass the request upstream" do
      upstream.should_not_receive(:call)
      subject.call(env)
    end

    it 'returns a 406' do
      status, headers, body = *subject.call(env)
      status.should == 406
      headers['Content-Type'].should == 'text/plain'
      headers['Content-Length'].should == body.first.length.to_s
      body.should == [ 'Not Acceptable' ]
    end
  end

end
