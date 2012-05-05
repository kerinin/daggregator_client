module Daggregator
  require 'daggregator_client/client'
  require 'daggregator_client/configuration'

  def self.client
    @client ||= Client.new
  end
end
