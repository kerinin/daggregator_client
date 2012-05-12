module Daggregator
  class Configuration
    attr_accessor :server, :port, :get_node_cb, :get_aggregates_cb, :put_node_cb, :put_flow_cb, :delete_key_cb, :delete_flow_cb, :delete_node_cb

    def initialize(options={})
      defaults = {
        :port =>              '80'
      }
      options.merge! defaults
      @server             = options[:server]
      @port               = options[:port]
    end
  end
end
