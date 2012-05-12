module Daggregator::Model::Serialization
  def to_node_for(type)
    type = type.to_s
    {
      'identifier' => identifier_for(type),
      'data' => node_data_for(type)
    }
  end

  def to_flows_to_for(type)
    type = type.to_s
    flows = []
    daggregator_options[type].flows_to.each_pair do |association_name, association_hash|
      # association_name is the model association which returns related instances
      flows += Array(send(association_name).instance_eval(&association_hash['block'])).map do |associated|
        # Construct the identifiers for related instance `associated`, given node types
        associated_identifiers_for(associated, association_hash['types'])
      end
    end
    flows.flatten.uniq
  end

  def to_flows_from_for(type)
    type = type.to_s
    flows = []
    daggregator_options[type].flows_from.each_pair do |association_name, association_hash|
      # association_name is the model association which returns related instances
      flows += Array(send(association_name).instance_eval(&association_hash['block'])).map do |associated|
        # Construct the identifiers for related instance `associated`, given node types
        associated_identifiers_for(associated, association_hash['types'])
      end
    end
    flows.flatten.uniq
  end

  def identifier_for(type)
    type = type.to_s
    if type == 'default'
      type = self.class.name
    end
    instance_eval &daggregator_options[type].identifier_proc
  end
  

  # Private Methods
  
  def daggregator_options
    self.class.daggregator_options
  end

  def associated_identifiers_for(associated, related_types)
    related_types.map {|type| associated.identifier_for(type) }
  end

  def node_data_for(type)
    type = type.to_s
    data = {}
    daggregator_options[type].keys.each_pair do |key,block|
      data[key.to_s] = instance_eval &block
    end
    data
  end
end
