module Daggregator::Model::Aggregation
  def aggregate_sum_for(type, keys)
    Daggregator.get_aggregates(identifier_for(type), 'sum', keys)['sum']
  end

  def aggregate_count_for(type, keys)
    Daggregator.get_aggregates(identifier_for(type), 'count', keys)['count']
  end

  def aggregate_distribution_for(type, keys)
    Daggregator.get_aggregates(identifier_for(type), 'distribution', keys)['distribution']
  end

  def aggregate_bin_count_for(type, keys, bins)
    Daggregator.get_aggregates(identifier_for(type), 'bin_count', keys, {'bins' => bins})['bin_count']
  end
end
