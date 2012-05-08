module Daggregator::Model::ClassMethods
  attr_reader :daggregator_options

  def aggregate_to(type=self.name)
    type = type.to_s

    @daggregator_options ||= {}
    daggregator_options[type] ||= Daggregator::Model::GraphBuilder.new
    yield daggregator_options[type]
  end
end
