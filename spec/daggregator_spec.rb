require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Daggregator do
  describe "client" do
    it "returns an instance of Daggregator::Client" do
      Daggregator.client.should be_a(Daggregator::Client)
    end
  end
end

describe Daggregator::Client do
  subject { Daggregator::Client.new }

  its(:configuration) { should be_a(Daggregator::Configuration) }

  describe "configure" do
    it "sets config values" do
      subject.configure do |config|
        config.server = 'testing'
      end
      subject.configuration.server.should == 'testing'
    end
  end
end
