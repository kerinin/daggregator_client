module Daggregator
  class Configuration
    attr_accessor :server, :port, :get_node_cb, :get_aggregates_cb, :put_node_cb, :put_flow_cb, :delete_key_cb, :delete_flow_cb, :delete_node_cb

    def initialize(options={})
      defaults = {
        :port =>              '80',
        :get_node_cb =>       lambda {},
        :get_aggregates_cb => lambda {},
        :put_node_cb =>       lambda {},
        :put_flow_cb =>       lambda {},
        :delete_key_cb =>     lambda {},
        :delete_flow_cb =>    lambda {},
        :delete_node_cb =>    lambda {}
      }
      options.merge! defaults
      @server             = options[:server]
      @port               = options[:port]
      @get_node_cb        = options[:get_node_cb]
      @get_aggregates_cb  = options[:get_aggregates_cb]
      @put_node_cb        = options[:put_node_cb]
      @put_flow_cb        = options[:put_flow_cb]
      @delete_key_cb      = options[:delete_key_cb] 
      @delete_flow_cb     = options[:delete_flow_cb]
      @delete_node_cb     = options[:delete_node_cb]
    end
  end
end
