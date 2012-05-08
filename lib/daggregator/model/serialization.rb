module Daggregator::Model::Serialization
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
  

  # Private Methods
  
  def daggregator_options
    self.class.daggregator_options
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
      data[key.to_s] = instance_eval &block
    end
    data
  end
end
