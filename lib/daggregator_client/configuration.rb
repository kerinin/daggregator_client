class Daggregator::Configuration
  attr_accessor :server

  def initialize(options={})
    defaults = {
      # Defaults here
    }
    options.merge! defaults
    @server = options[:server]
  end
end
