require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test_model'

describe Daggregator::Model do
  before(:each) { TestModel.new }   # Force class to be built
  subject { TestModel }

  it "creates options with no arguments" do
    subject.daggregator_options['TestModel'].should be_true
  end

  it "creates options with an argument" do
    subject.daggregator_options['two'].should be_true
  end

  describe "identifier_for" do
    subject { TestModel.new }

    it "creates from class name and id" do
      subject.identifier_for('TestModel').should == 'TestModel_1'
    end

    it "creates from passed argument" do
      subject.identifier_for('three').should == 'identifier_three_1'
    end

    it "creates from passed block" do
      subject.identifier_for('two').should == 'identifier_two'
    end
  end

  describe "to_node_for" do
    subject { TestModel.new.to_node_for('TestModel')['data'] }

    it "generates keys from attributes" do
      subject['property_1'].should == 'property 1'
    end

    it "generates keys from other attributes" do
      subject['renamed_property'].should == 'property 1'
    end

    it "generates keys from passed blocks" do
      subject['proc_property'].should == 'property 1'
    end
  end

  describe "to_flows_for" do
    subject { TestModel.new }
  
    it "creates flows for associations" do
      subject.to_flows_for('two').should include('TestModel_1')
    end

    it "creates flows for renamed associations" do
      subject.to_flows_for('TestModel').should include('identifier_two')
    end
  end
end
