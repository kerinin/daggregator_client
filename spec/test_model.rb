class TestModel
  include ActiveModel::Callbacks
  include Daggregator::Model

  aggregate_to do |node|
    node.key :property_1
    node.key :renamed_property, :from => :property_1
    node.key :proc_property do
      property_1
    end

    node.flow_to :fake_association, :as => :two
  end

  aggregate_to(:two) do
    node.identifier do |test_model|
      "identifier_#{test_model.two}"
    end

    node.key :property_2
    node.key :renamed_property, :from => :property_2
    node.key :proc_property do
      property_2
    end

    node.flow_to :fake_association
  end

  aggregate_to("three") do
    node.identifier :identifier_three
  end

  def property_1
    'property 1'
  end

  def property_2
    'property_2'
  end

  def fake_association
    [0..3].map { TestModel.new }
  end

  def two
    "two"
  end
end
