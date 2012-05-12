$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'daggregator/configuration'
require 'daggregator/connection'

module Daggregator
  class << self  
    def client
      @client ||= Client.new
    end

    def configuration
      @configuration ||= Daggregator::Configuration.new
    end
    alias :config :configuration

    def configure
      yield configuration
    end

    def get_node(node_id)
      connection.get(
        "/nodes/#{node_id}.json"
      )
    end

    def get_aggregates(node_id, function, keys)
      keys = Array(keys)
      connection.get(
        "/nodes/#{node_id}/#{ensure_function_exists(function)}/#{keys.join('+')}.json"
      )
    end

    def put_node(node_id, key_hash={})
      connection.put(
        "/nodes/#{node_id}.json", 
        key_hash
      )
    end

    def put_flow_to(source_id, target_ids)
      target_ids = Array(target_ids)
      # For large arrays, the URL becomes too long to be processed, so we'll
      # split this into multiple calls
      target_ids.each_slice(10) do |batch_targets|
        connection.put(
          "/nodes/#{source_id}/flow_to/#{batch_targets.join('+')}.json"
        )
      end
    end

   def put_flow_from(target_id, source_ids)
      source_ids = Array(source_ids)
      source_ids.each_slice(10) do |batch_sources|
        connection.put(
          "/nodes/#{target_id}/flow_from/#{batch_sources.join('+')}.json"
        )
      end
    end

    def delete_key(node_id, key)
      connection.delete(
        "/nodes/#{node_id}/key/#{key}.json"
      )
    end

    def delete_flow(source_id, target_id)
      connection.delete(
        "/nodes/#{source_id}/flow_to/#{target_id}.json"
      )
    end

    def delete_node(node_id)
      connection.delete(
        "/nodes/#{node_id}.json"
      )
    end

    # Private Methods
    
    def connection
      @connection ||= Daggregator::Connection.new
    end

    def ensure_function_exists(function)
      unless [:sum, :count].include? function.to_sym
        raise Daggregator::UnknownAggregationFunction 
      else
        function
      end
    end
  end
end
