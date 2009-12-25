# Describes a geographical location.
class YahooWeather::Location
  # the name of the city.
  attr_reader :city

  # the name of the country.
  attr_reader :country

  # the name of the region, such as a state.
  attr_reader :region

  def initialize (payload)
    @city = payload['city']
    @country = payload['country']
    @region = payload['region']
  end
end
