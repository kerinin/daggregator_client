class TestModel
  attr_accessor :id
  include Daggregator::Model

  def initialize(id=3)
    @id = id
  end

  def property
    'value'
  end

  def associated
    (1..3).to_a.map {|i| TestModel.new(i) }
  end
end
