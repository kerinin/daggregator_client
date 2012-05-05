require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daggregator::Configuration do
  describe "initialize" do
    it "accepts an options hash" do
      Daggregator::Configuration.new(:server => 'testing').server.should == 'testing'
    end
  end
end
