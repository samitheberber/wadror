json.array!(@beers) do |beer|
  json.extract! beer, :name, :style, :brewery
  json.url beer_url(beer, format: :json)
end
