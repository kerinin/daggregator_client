require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'daggregator/model'

describe Daggregator::Model::Serialization do
  before(:each) do
    class TestClass
      attr_accessor :id
      include Daggregator::Model

      def initialize(id=3)
        @id = id
      end

      def associated
        [1..3].map {|i| TestClass.new(i) }
      end
    end
  end

  describe "to_node_for" do
    before(:each) do
      TestClass.aggregate_to(:foo) do |node| end;
    end
    subject { TestClass.new }

    it "constructs hash with identifier" do
      subject.to_node_for(:foo)['identifier'].should be_true
    end

    it "constructs hash with data" do
      subject.to_node_for(:foo)['data'].should be_true
    end

    it "inserts identifier" do
      subject.should_receive(:identifier_for).with('foo')
      subject.to_node_for(:foo)
    end

    it "inserts node data" do
      subject.should_receive(:node_data_for).with('foo')
      subject.to_node_for(:foo)
    end
  end

  describe "to_flows_for" do
    before(:each) do
      TestClass.aggregate_to do |node|
        node.flow_to :associated, :as => :foo
      end
      TestClass.aggregate_to(:foo) do |node|
        node.flow_to :associated
      end
    end
    subject { TestClass.new }

    it "includes associated" do
      subject.to_flows_for('foo').should include('TestClass_1')
    end

    it "includes associated with :as" do
      subject.to_flows_for('TestClass').should include('foo_1')
    end
  end

  describe "identifier_for" do
    it "evaluates identifier proc in instance's scope"
  end

  describe "node_data_for" do
    it "returns a hash for each key"

    it "calls each key's proc in the instance's scope"
  end
end
