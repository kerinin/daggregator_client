require 'uri'
require 'rest-client'
require 'json'

class Daggregator::Connection
  def get(path, params={})
    response = RestClient.get uri_from(path), :params => params, :content_type => :json, :accept => :json
    JSON.parse(response.body)
  end

  def put(path, data={})
    response = RestClient.put uri_from(path), format_data(data), :content_type => :json, :accept => :json
    JSON.parse(response.body)
  end

  def delete(path)
    response = RestClient.delete uri_from(path), :content_type => :json, :accept => :json
    JSON.parse(response.body)
  end

  # Private Methods
  
  def uri_from(path, query = nil)
    URI::Generic.build(
      :scheme => 'http', 
      :host => Daggregator.config.server, 
      :port => Daggregator.config.port.to_i,
      :path => path, 
      :query => query
    ).to_s
  end

  def format_data(params)
    {:node => { :data => params } }
  end
end
