module Daggregator::Model::RestAPI
  def put_neo
    put_nodes
    put_flows
  end

  def delete_neo
    delete_nodes
    delete_flows
  end

  def put_nodes
    daggregator_options.each_key do |type|
      Daggregator.put_node( identifier_for(type), node_data_for(type) )
    end
  end

  def put_flows
    daggregator_options.each_key do |type|
      targets = to_flows_for(type)
      Daggregator.put_flow( identifier_for(type), targets) unless targets.empty?
    end
  end

  def delete_nodes
    daggregator_options.each_key do |type|
      Daggregator.delete_node( identifier_for(type) )
    end
  end

  def delete_flows
    daggregator_options.each_key do |type|
      targets = to_flows_for(type)
      Daggregator.delete_flow( identifier_for(type), targets) unless targets.empty?
    end
  end
end
