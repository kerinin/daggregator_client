module Daggregator::Model::RestAPI
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
end
