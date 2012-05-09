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
        @c.should_receive(:get).with('/nodes/foo.json')
        subject.get_node('foo')      
      end
    end

    describe "get_aggregates" do
      it "calls connection" do
        @c.should_receive(:get).with('/nodes/foo/sum/bar.json')
        subject.get_aggregates('foo', 'sum', 'bar')      
      end

      it "takes an array of attributes" do
        @c.should_receive(:get).with('/nodes/foo/sum/bar+baz.json')
        subject.get_aggregates('foo', 'sum', ['bar', 'baz'])      
      end

      it "accepts symbols" do
        @c.should_receive(:get).with('/nodes/foo/sum/bar+baz.json')
        subject.get_aggregates(:foo, :sum, [:bar, :baz])
      end
    end

    describe "put_node" do
      it "calls connection" do
        @c.should_receive(:put).with('/nodes/foo.json', {:bar => 1, :baz => 2})
        subject.put_node('foo', {:bar => 1, :baz => 2})      
      end

      it "accepts empty hash" do
        @c.should_receive(:put).with('/nodes/foo.json', {})
        subject.put_node('foo')
      end
    end

    describe "put_flow_to" do
      it "calls connection" do
        @c.should_receive(:put).with('/nodes/source/flow_to/target.json')
        subject.put_flow_to('source', 'target')      
      end

      it "accepts an arry of targets" do
        @c.should_receive(:put).with('/nodes/source/flow_to/target1+target2.json')
        subject.put_flow_to('source', ['target1', 'target2'])
      end
    end

    describe "put_flow_from" do
      it "calls connection" do
        @c.should_receive(:put).with('/nodes/target/flow_from/source.json')
        subject.put_flow_from('target', 'source')      
      end

      it "accepts an arry of targets" do
        @c.should_receive(:put).with('/nodes/target/flow_from/source1+source2.json')
        subject.put_flow_from('target', ['source1', 'source2'])
      end
    end

    describe "delete_key" do
      it "calls connection" do
        @c.should_receive(:delete).with('/nodes/foo/key/bar.json')
        subject.delete_key('foo', 'bar')
      end
    end

    describe "delete_flow" do
      it "calls connection" do
        @c.should_receive(:delete).with('/nodes/source/flow_to/target.json')
        subject.delete_flow('source', 'target')
      end
    end

    describe "delete_node" do
      it "calls connection" do
        @c.should_receive(:delete).with('/nodes/foo.json')
        subject.delete_node('foo')
      end
    end
  end
end
