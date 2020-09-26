def get_random_gif(query)
    client = get_giphy_client
    gifs = get_gifs(client, query)
end

def get_giphy_client
    client = GiphyClient::DefaultApi.new
end

def get_gifs(client, query)
    api_key = ENV['GIPHY_API_KEY'] # String | Giphy API Key.

    q = query # String | Search query term or prhase.

    opts = { 
    limit: 25, # Integer | The maximum number of records to return.
    offset: 0, # Integer | An optional results offset. Defaults to 0.
    rating: "r", # String | Filters results by specified rating.
    lang: "en", # String | Specify default country for regional content; use a 2-letter ISO 639-1 country code. See list of supported languages <a href = \"../language-support\">here</a>.
    fmt: "json" # String | Used to indicate the expected response format. Default is Json.
    }

    begin
        #Search Endpoint
        result = client.gifs_search_get(api_key, q, opts)
        rescue GiphyClient::ApiError => e
        puts "Exception when calling DefaultApi->gifs_search_get: #{e}"
    end
end

