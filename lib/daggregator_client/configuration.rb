class Daggregator::Configuration
  attr_accessor :server

  def initialize(options={})
    defaults = {
      # Defaults heer
    }
    options.merge! defaults
    @server = options[:server]
  end
end
