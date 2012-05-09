require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'daggregator/model'

describe Daggregator::Model::GraphBuilder do
  subject { Daggregator::Model::GraphBuilder.new }

  describe "initialize" do
    its(:identifier_proc) { should be_true }
    its(:keys) {should be_true }
    its(:flows_to) {should be_true }
    its(:flows_from) {should be_true }

    it "creates default identifier using class name and id" do
      mock = double(:id => '2')
      subject.identifier_proc.call(mock).should == 'RSpec::Mocks::Mock_2'
    end
  end

  describe "key" do
    it "creates a new key with the passed name" do
      subject.key(:foo)
      subject.keys['foo'].should be_a(Proc)
    end

    it "creates default proc by sending argument" do
      mock = double(:foo => 'bar')
      subject.key(:foo)
      mock.instance_eval(&subject.keys['foo']).should == 'bar'
    end

    it "creates proc with :from" do
      mock = double(:foo => 'no', :bar => 'yes')
      subject.key(:foo, :from => :bar)
      mock.instance_eval(&subject.keys['foo']).should == 'yes'
    end

    it "creates proc from passed block" do
      mock = double(:foo => 'no', :bar => 'yes')
      subject.key(:foo) do
        bar
      end
      mock.instance_eval(&subject.keys['foo']).should == 'yes'
    end
  end

  describe "flow_to" do
    it "creates a new key with the passed name" do
      subject.flow_to(:foo)
      subject.flows_to['foo'].should be_a(Array)
    end

    it "defaults to default" do
      # NOTE: this uses the node type named after the target's class name
      subject.flow_to(:foo)
      subject.flows_to['foo'].should include('default')
    end

    it "creates flow with :as" do
      subject.flow_to(:foo, :as => :bar)
      subject.flows_to['foo'].should include('bar')
    end
  end

  describe "flow_from" do
    it "creates a new key with the passed name" do
      subject.flow_from(:foo)
      subject.flows_from['foo'].should be_a(Array)
    end

    it "defaults to default" do
      # NOTE: this uses the node type named after the target's class name
      subject.flow_from(:foo)
      subject.flows_from['foo'].should include('default')
    end

    it "creates flow with :as" do
      subject.flow_from(:foo, :as => :bar)
      subject.flows_from['foo'].should include('bar')
    end
  end
end
