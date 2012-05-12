module Daggregator::Model
  require 'daggregator/model/rest_api'
  require 'daggregator/model/serialization'
  require 'daggregator/model/class_methods'
  require 'daggregator/model/graph_builder'
  require 'daggregator/model/aggregation'

  include RestAPI
  include Serialization
  include Aggregation

  def self.included(base)
    base.extend ClassMethods
  end
end
