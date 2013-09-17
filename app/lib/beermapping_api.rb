class BeermappingAPI
  def self.find(id)
    Place
    field = "place_#{id}"
    unless Rails.cache.exist? field
      Rails.cache.write field, fetch_place(id)
    end
    Rails.cache.read field
  end

  def self.places_in(city)
    Place
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

  def self.fetch_place(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]
    return nil if place.is_a?(Hash) and place['id'].nil?
    Place.new(place.merge fetch_place_scores(id))
  end

  def self.fetch_place_scores(id)
    url = "http://beermapping.com/webservice/locscore/#{key}/#{id}"
    response = HTTParty.get url
    response.parsed_response["bmp_locations"]["location"]
  end

  def self.key
    Settings.beermapping_apikey
  end
end
