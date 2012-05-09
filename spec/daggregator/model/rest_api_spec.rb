require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'daggregator/model'
require 'test_model'

describe Daggregator::Model::ClassMethods do
  describe "put_nodes" do
    before(:each) do
      TestModel.aggregate_to do |node|
        node.key :property
        node.flow_to :associated, :as => :foo
      end
      TestModel.aggregate_to(:foo) do |node|
        node.key :property
      end
    end
    subject { TestModel.new(1) }

    it "sends put_node with hash" do
      Daggregator.should_receive(:put_node).with(
        'TestModel_1',
        {'property' => 'value'}  
      )
      Daggregator.should_receive(:put_node).with(
        'foo_1',
        {'property' => 'value'}
      )
      subject.put_nodes
    end
  end

  describe "put_flows" do
    before(:each) do 
      TestModel.aggregate_to do |node|
        node.flow_to :associated, :as => :foo
        node.flow_from :associated, :as => :foo
      end
      TestModel.aggregate_to(:foo) do |node|
        node.flow_to :associated
        node.flow_from :associated
      end
      Daggregator.stub(:put_flow_to)
      Daggregator.stub(:put_flow_from)
    end
    subject { TestModel.new(1) }

    it "sends put_flow_to with hash" do
      Daggregator.should_receive(:put_flow_to).with('TestModel_1', ['foo_1', 'foo_2', 'foo_3'] )
      Daggregator.should_receive(:put_flow_to).with('foo_1', ['TestModel_1', 'TestModel_2', 'TestModel_3'] )
      subject.put_flows
    end
    
    it "sends put_flow_from with hash" do
      Daggregator.should_receive(:put_flow_from).with('TestModel_1', ['foo_1', 'foo_2', 'foo_3'] )
      Daggregator.should_receive(:put_flow_from).with('foo_1', ['TestModel_1', 'TestModel_2', 'TestModel_3'] )
      subject.put_flows
    end
  end

  describe "delete_nodes" do
  end

  describe "delete_flows" do
  end
end
