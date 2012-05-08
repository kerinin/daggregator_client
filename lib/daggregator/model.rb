module Daggregator::Model
  require 'daggregator/model/rest_api'
  require 'daggregator/model/serialization'
  require 'daggregator/model/class_methods'
  require 'daggregator/model/graph_builder'

  include RestAPI
  include Serialization

  def self.included(base)
    base.extend ClassMethods
  end
end
