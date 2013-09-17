class BeermappingAPI
  def self.places_in(city)
    Place # varmistaa, että luokan koodi on ladattu
    city = city.downcase
    write_current(city) unless Rails.cache.exist? city

    time, data = Rails.cache.read city
    if time < 1.hour.ago
      write_current(city)
      _, data = Rails.cache.read city
    end
    data
  end

  private

  def self.write_current(city)
    Rails.cache.write city, [Time.now, fetch_places_in(city)]
  end

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do |set, place|
      set << Place.new(place)
    end
  end

  def self.key
    "e8f0942cf829432dbc72e8e3846d8f61"
  end
end
