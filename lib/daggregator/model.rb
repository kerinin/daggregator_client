module Daggregator::Model
  module ClassMethods
    attr_reader :daggregator_options

    def aggregate_to(type=self.name)
      type = type.to_s

      @daggregator_options ||= {}
      daggregator_options[type] ||= ModelOptions.new
      yield daggregator_options[type]
    end
  end

  def put_nodes
    daggregator_options.each_key do |type|
      Daggregator.put_node( to_node_for(type) )
    end
  end

  def put_flows
    daggregator_options.each_key do |type|
      Daggregator.put_flow( identifier_for(type), to_flows_for(type) )
    end
  end

  def delete_nodes
    daggregator_options.each_key do |type|
      Daggregator.delete_node( identifier_for(type) )
    end
  end

  def delete_flows
    daggregator_options.each_key do |type|
      Daggregator.delete_flow( identifier_for(type), to_flows_for(type) )
    end
  end


  # Private Methods

  def daggregator_options
    self.class.daggregator_options
  end

  def to_node_for(type)
    type = type.to_s
    {
      'identifier' => identifier_for(type),
      'data' => node_data_for(type)
    }
  end

  def to_flows_for(type)
    type = type.to_s
    flows = []
    daggregator_options[type].flows.each_key do |association_name|
      flows += send(association_name).map do |associated|
        associated_identifiers_for(type, association_name)
      end
    end
  end

  def identifier_for(type)
    type = type.to_s
    instance_eval &self.class.daggregator_options[type].identifier_proc
  end
  
  def associated_identifiers_for(type, association_name)
    type = type.to_s
    associated_types = self.class.daggregator_options[type].flows[association_name]
    associated_types.map {|association_name| send(type).identifier_for(type) }
  end

  def node_data_for(type)
    type = type.to_s
    data = {}
    self.class.daggregator_options[type].keys.each_pair do |key,block|
      begin
        data[key.to_s] = instance_eval &block
      rescue
      end
    end
    data
  end

  class ModelOptions
    attr_reader :identifier_proc, :keys, :flows

    def initialize
      @identifier_proc  = Proc.new {|instance| "#{instance.class.name}_#{instance.id}" }
      @keys             = {}
      @flows            = {}
    end

    def identifier(prefix = nil, &block)
      if not prefix and not block_given?
        raise ArgumentError "Why are you calling identifier with no arguments?"
      elsif prefix
        block = Proc.new {|instance| "#{prefix}_#{instance.id}" }
      end

      @identifier_proc = block
    end

    def key(key_name, args={}, &block)
      if not key_name
        raise ArgumentError, "You must tell me what key you want to push to"
      end

      if not block_given? and not args[:from]
        block = Proc.new { send(key_name) }
      elsif args[:from]
        block = Proc.new { send(args[:from]) }
      elsif not block_given?
        block = Proc.new { send(key_name) }
      end

      @keys[key_name] = block
    end

    def flow_to(association_name, args={})
      # RM NOTE: you should probably set up identifier for the target class 
      # if it isn't already

      @flows[association_name] ||= []
      @flows[association_name] << ( args[:as] || association_name )
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
