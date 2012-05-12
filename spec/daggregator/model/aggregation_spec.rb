require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'daggregator/model'
require 'test_model'

describe Daggregator::Model::Aggregation do
  before(:each) do
    Daggregator.stub(:get_aggregates).and_return({})
    TestModel.aggregate_to {|node|}
  end
  subject { TestModel.new }

  describe "aggregate_sum_for" do
    it "calls aggregate" do
      Daggregator.should_receive(:get_aggregates).with('TestModel_3', 'sum', :key)
      subject.aggregate_sum_for('TestModel', :key)
    end
  end

  describe "aggregate_count" do
    it "calls aggregate" do
      Daggregator.should_receive(:get_aggregates).with('TestModel_3', 'count', :key)
      subject.aggregate_count_for('TestModel', :key)
    end
  end

  describe "aggregate_distribution" do
    it "calls aggregate" do
      Daggregator.should_receive(:get_aggregates).with('TestModel_3', 'distribution', :key)
      subject.aggregate_distribution_for('TestModel', :key)
    end
  end

  describe "aggregate_bin_count" do
    it "calls aggregate" do
      Daggregator.should_receive(:get_aggregates).with('TestModel_3', 'bin_count', :key, {'bins' => 5})
      subject.aggregate_bin_count_for('TestModel', :key, 5)
    end
  end
end
