module CustomHelpers
  
  def get_json(url)
    get url
    json = JSON.parse response.body
    json.symbolize_keys
  end
  
end

include CustomHelpers