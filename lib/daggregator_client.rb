module Daggregator
  require 'daggregator_client/configuration'

  def self.client
    @client ||= Client.new
  end

  class Client
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
