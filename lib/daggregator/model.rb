module Daggregator::Model
  module ClassMethods
    attr_reader :daggregator_options

    def aggregate_to(type=self.name)
      @daggregator_options[type] ||= ModelOptions.new(type)
      yield @daggregator_options[type]
    end
  end

  module InstanceMethods
    def put_nodes
      @daggregator_options.each_key do |type|
        Daggregator.put_node( to_node_for(type) )
      end
    end

    def put_flows
      @daggregator_options.each_key do |type|
        Daggregator.put_flow( identifier_for(type), to_flows_for(type) )
      end
    end

    def put_flows_for(associated)
      @daggregator_options.each_key do |type|
        Daggregator.put_flow( identifier_for(type), associated_identifiers_for(type, associated) )
      end
    end

    def delete_nodes
      @daggregator_options.each_key do |type|
        Daggregator.delete_node( identifier_for(type) )
      end
    end

    def delete_flows
      @daggregator_options.each_key do |type|
        Daggregator.delete_flow( identifier_for(type), to_flows_for(type) )
      end
    end

    def delete_flows_for(associated)
      @daggregator_options.each_key do |type|
        Daggregator.delete_flow( identifier_for(type), associated_identifiers_for(type, associated) )
      end
    end

    # Private Methods

    def to_node_for(type)
      {
        :identifier => identifier_for(type)
        :data => node_data_for(type)
      }
    end

    def to_flows_for(type)
      flows = []
      @daggregator_options[type].flows.each_key do |association_name|
        flows += send(association_name).map do |associated|
          associated_identifiers_for(type, associated)
        end
      end
    end

    def identifier_for(type)
      instance_eval @daggregator_options[type].identifier_proc
    end
    
    def associated_identifiers_for(type, associated)
      associated_types = @daggregator_options[type].flows[association_name]
      associated_types.map {|type| associated.identifier_for(type) }
    end

    def node_data_for(type)
      data = {}
      @daggregator_options[type].keys.each_pair do |key,block|
        data[key] = instance_eval(block)
      end
      data
    end
  end


  class ModelOptions
    attr_reader :identifier_proc, :keys, :flows

    def identifier(&block)
      @identifier_proc = block
    end

    def key(key_name, from = nil, &block)
      if block && key
        raise ArgumentError, "Specify either a block or a 'from' value"
      elsif from
        block = lambda { send(from) }
      else
        block = lambda { send(key_name) }
      end

      @keys[key_name] = block
    end

    def flow_to(association_name, associated_type)
      # RM NOTE: you should probably set up identifier for the target class 
      # if it isn't already

      @flows[association_name] ||= []
      @flows[association_name] << associated_type
    end
  end

  def included
    extend ClassMethods
    include InstanceMethods
  end
end
