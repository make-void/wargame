module CustomHelpers
  
  def get_json(url)
    get url
    parse_json response
  end
  
  def post_json(url, params={})
    post url, params
    parse_json response
  end
  
  # private
  
  def parse_json(response)
    json = JSON.parse response.body
    json.symbolize_keys! if json.is_a? Hash
    json
  end
  
end

include CustomHelpers