require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'daggregator/model'

describe Daggregator::Model::ClassMethods do
  before(:each) do
    class TestModel
      extend Daggregator::Model::ClassMethods
    end
  end

  it "creates daggregator_options" do
    TestModel.aggregate_to do |node| end;
    TestModel.daggregator_options.should be_true
  end

  it "creates type with class name if no argument" do
    TestModel.aggregate_to do |node| end;
    TestModel.daggregator_options['TestModel'].should be_a(Daggregator::Model::GraphBuilder)
  end

  it "creats type with passed argument" do
    TestModel.aggregate_to('foo') do |node| end;
    TestModel.daggregator_options['foo'].should be_a(Daggregator::Model::GraphBuilder)
  end

  it "converts symbol arguments to strings" do
    TestModel.aggregate_to(:foo) do |node| end;
    TestModel.daggregator_options['foo'].should be_a(Daggregator::Model::GraphBuilder)
  end

  it "yields to block with builder" do
    pending "Rspec adhering to its API"
    expect {|b| TestModel.aggregate_to(&b) }.to yield_with_args(Daggregator::Model::GraphBuilder)
  end
end
