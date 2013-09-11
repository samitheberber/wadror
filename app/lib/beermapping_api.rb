class BeermappingAPI
  def self.places_in city
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    return places.inject([]) do |set, place|
      set << Place.new(place)
    end
  end

  def self.key
    "e8f0942cf829432dbc72e8e3846d8f61"
  end
end
