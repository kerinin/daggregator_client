require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Daggregator do
  subject { Daggregator }

  its(:configuration) { should be_a(Daggregator::Configuration) }

  describe "configure" do
    it "sets config values" do
      subject.configure do |config|
        config.server = 'testing'
      end
      subject.configuration.server.should == 'testing'
    end
  end

  context "with stubbed connection" do
    before(:each) do
      @c = Daggregator.connection
      @c.stub(:get).and_return({})
      @c.stub(:put).and_return({})
      @c.stub(:delete).and_return({})
    end

    describe "get_node" do
      it "calls connection" do
        l = Daggregator.config.get_node_cb
        @c.should_receive(:get).with('/node/foo', l)
        subject.get_node('foo')      
      end
      
      it "takes a callback" do
        l = lambda {|cb| puts cb}
        @c.should_receive(:get).with('/node/foo', l)
        subject.get_node('foo', &l)
      end
    end

    describe "get_aggregates" do
      it "calls connection" do
        l = Daggregator.config.get_aggregates_cb
        @c.should_receive(:get).with('/node/foo/sum/bar', l)
        subject.get_aggregates('foo', 'sum', 'bar')      
      end
      
      it "takes a callback" do
        l = lambda {|cb| puts cb}
        @c.should_receive(:get).with('/node/foo/sum/bar', l)
        subject.get_aggregates('foo', 'sum', 'bar', &l)      
      end

      it "takes an array of attributes" do
        l = Daggregator.config.get_aggregates_cb
        @c.should_receive(:get).with('/node/foo/sum/bar+baz', l)
        subject.get_aggregates('foo', 'sum', ['bar', 'baz'])      
      end

      it "accepts symbols" do
        l = Daggregator.config.get_aggregates_cb
        @c.should_receive(:get).with('/node/foo/sum/bar+baz', l)
        subject.get_aggregates(:foo, :sum, [:bar, :baz])
      end
    end

    describe "put_node" do
      it "calls connection" do
        l = Daggregator.config.put_node_cb
        @c.should_receive(:put).with('/node/foo', {:bar => 1, :baz => 2}, l)
        subject.put_node('foo', {:bar => 1, :baz => 2})      
      end
      
      it "takes a callback" do
        l = lambda {|cb| puts cb}
        @c.should_receive(:put).with('/node/foo', {:bar => 1, :baz => 2}, l)
        subject.put_node('foo', {:bar => 1, :baz => 2}, &l)
      end
    end

    describe "put_flow" do
      it "calls connection" do
        l = Daggregator.config.put_flow_cb
        @c.should_receive(:put).with('/node/source/flow_to/target', l)
        subject.put_flow('source', 'target')      
      end
      
      it "takes a callback" do
        l = lambda {|cb| puts cb}
        @c.should_receive(:put).with('/node/source/flow_to/target', l)
        subject.put_flow('source', 'target', &l)
      end

      it "accepts an arry of targets" do
        l = Daggregator.config.put_flow_cb
        @c.should_receive(:put).with('/node/source/flow_to/target1+target2', l)
        subject.put_flow('source', ['target1', 'target2'])
      end
    end
  end
end
