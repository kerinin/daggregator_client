require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'daggregator/model'

describe Daggregator::Model::Serialization do
  before(:each) do
    class TestClass < Object
      attr_accessor :id
      include Daggregator::Model

      def initialize(id=3)
        @id = id
      end

      def property
        'value'
      end

      def associated
        (1..3).to_a.map {|i| TestClass.new(i) }
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

  describe "to_flows_to_for" do
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
      subject.to_flows_to_for('foo').should include('TestClass_1')
    end

    it "includes associated with :as" do
      subject.to_flows_to_for('TestClass').should include('foo_1')
    end
  end

  describe "to_flows_from_for" do
    before(:each) do
      TestClass.aggregate_to do |node|
        node.flow_from :associated, :as => :foo
      end
      TestClass.aggregate_to(:foo) do |node|
        node.flow_from :associated
      end
    end
    subject { TestClass.new }

    it "includes associated" do
      subject.to_flows_from_for('foo').should include('TestClass_1')
    end

    it "includes associated with :as" do
      subject.to_flows_from_for('TestClass').should include('foo_1')
    end
  end

  describe "identifier_for" do
    before(:each) do
      TestClass.aggregate_to do |node|
        node.identifier(:foo)
      end
    end
    subject { TestClass.new(3) }

    it "evaluates identifier proc in instance's scope" do
      subject.identifier_for('TestClass').should == 'foo_3'
    end
  end

  describe "node_data_for" do
    before(:each)  do
      TestClass.aggregate_to do |node|
        node.key :property
        node.key :foo, :from => :property
        node.key :bar do
          property
        end
      end
      TestClass.aggregate_to(:custom) do |node| end;
    end
    subject { TestClass.new(3) }

    it "returns a hash for default type" do
      subject.node_data_for('TestClass').should be_a(Hash)
    end

    it "returns a hash for specific types" do
      subject.node_data_for(:custom).should be_a(Hash)
    end

    it "calls procs for default keys" do
      subject.node_data_for('TestClass')['property'].should == 'value'
    end

    it "calls procs for renamed keys" do
      subject.node_data_for('TestClass')['foo'].should == 'value'
    end

    it "calls custom procs" do
      subject.node_data_for('TestClass')['bar'].should == 'value'
    end
  end
end
