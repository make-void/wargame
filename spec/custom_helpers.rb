module CustomHelpers
  
  def get_json(url)
    get url
    json = JSON.parse response.body
    json.symbolize_keys! if json.is_a? Hash
    json
  end
  
end

include CustomHelpers