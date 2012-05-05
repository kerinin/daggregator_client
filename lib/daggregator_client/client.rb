class Daggregator::Client
  attr_accessor :configuration

  def configuration
    @configuration ||= Daggregator::Configuration.new
  end

  def configure
    yield configuration
  end
end
