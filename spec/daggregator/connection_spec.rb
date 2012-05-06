require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daggregator::Connection do
  describe "uri_from" do
    before(:each) do
      Daggregator.configure do |c|
        c.server = 'server'
        c.port = '8000'
      end
    end
    subject { Daggregator::Connection.new }

    it "formats as expected" do
      subject.uri_from('/test', 'foo=bar').should == 'http://server:8000/test?foo=bar'
    end
  end
end
