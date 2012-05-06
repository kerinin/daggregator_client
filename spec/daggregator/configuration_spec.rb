require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daggregator::Configuration do
  describe "initialize" do
    it "accepts an options hash" do
      Daggregator::Configuration.new(:server => 'testing').server.should == 'testing'
    end

    describe "defaults" do
      subject { Daggregator::Configuration.new }

      its(:port) { should = '80' }
      its(:get_node_cb) { should be_a(Proc) }
      its(:get_aggregates_cb) { should be_a(Proc) }
      its(:put_node_cb) { should be_a(Proc) }
      its(:put_flow_cb) { should be_a(Proc) }
      its(:delete_key_cb) { should be_a(Proc) }
      its(:delete_flow_cb) { should be_a(Proc) }
      its(:delete_node_cb) { should be_a(Proc) }
    end
  end
end
