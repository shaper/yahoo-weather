require 'rubygems'
require 'test/unit'
require 'yahoo-weather'

class TestAPI < Test::Unit::TestCase
  def setup
    @client = YahooWeather::Client.new
  end

  def test_lookup_zip
    # check a seattle, wa zipcode
    request_location = '98103'
    response = @client.lookup_location(request_location)
    _assert_valid_response(response, request_location, 'f', 'Seattle', 'WA', 'US')
  end

  def test_lookup_location
    # check france just for fun with the sample france location code from the
    # yahoo weather developer page
    request_location = 'FRXX0076'
    response = @client.lookup_location(request_location)
    _assert_valid_response(response, request_location, 'f', 'Paris', '', 'FR')
  end

  def test_units
    request_location = '10001'
    city = 'New York'
    region = 'NY'
    country = 'US'

    # check explicitly specifying fahrenheit units
    response = @client.lookup_location(request_location, 'f')
    _assert_valid_response(response, request_location, 'f', city, region, country)

    # check alternate units
    response = @client.lookup_location(request_location, 'c')
    _assert_valid_response(response, request_location, 'c', city, region, country)
  end
  
  private

  def _assert_valid_response (response, request_location, units, city, region, country)
    assert_not_nil response

    # check the request location and url explicitly against what we know they should be
    assert_equal response.request_location, request_location
    assert_equal response.request_url, "http://xml.weather.yahoo.com/forecastrss?p=#{request_location}&u=#{units}"

    # check the astronomy info
    assert_instance_of YahooWeather::Astronomy, response.astronomy
    assert_instance_of Time, response.astronomy.sunrise
    assert_instance_of Time, response.astronomy.sunset
    assert (response.astronomy.sunrise < response.astronomy.sunset)

    # check the location
    assert_instance_of YahooWeather::Location, response.location
    assert_equal response.location.city, city
    assert_equal response.location.region, region
    assert_equal response.location.country, country

    # check the default units
    _assert_valid_units response.units, (units == 'f')

    # check the wind info
    assert_instance_of YahooWeather::Wind, response.wind
    assert (response.wind.chill <= response.condition.temp)
    assert_kind_of Numeric, response.wind.direction
    assert_kind_of Numeric, response.wind.speed
    
    # check the atmosphere info
    assert_instance_of YahooWeather::Atmosphere, response.atmosphere
    assert_kind_of Numeric, response.atmosphere.humidity
    assert_kind_of Numeric, response.atmosphere.visibility
    assert_kind_of Numeric, response.atmosphere.pressure
    assert (response.atmosphere.rising.is_a?(TrueClass) || response.atmosphere.rising.is_a?(FalseClass))

    # check the condition info
    assert_instance_of YahooWeather::Condition, response.condition
    _assert_valid_weather_code response.condition.code
    assert_instance_of Time, response.condition.date
    assert_kind_of Numeric, response.condition.temp
    assert (response.condition.text && response.condition.text.length > 0)

    # check the forecast info
    assert_not_nil response.forecasts
    assert_kind_of Array, response.forecasts
    assert_equal response.forecasts.length, 2
    response.forecasts.each do |forecast|
      assert_instance_of YahooWeather::Forecast, forecast
      assert (forecast.day && forecast.day.length == 3)
      assert_instance_of Time, forecast.date
      assert_kind_of Numeric, forecast.low
      assert_kind_of Numeric, forecast.high
      assert (forecast.low <= forecast.high)
      assert (forecast.text && forecast.text.length > 0)
      _assert_valid_weather_code forecast.code
    end
    
    # check the basic attributes
    assert (response.description && response.description.length > 0)
    assert (response.image_url =~ /yimg\.com/)
    assert_kind_of Numeric, response.latitude
    assert_kind_of Numeric, response.longitude
    assert (response.page_url =~ /\.html$/)
    assert (response.title && response.title.length > 0)
    assert_not_nil (response.title.index("#{response.location.city}, #{response.location.region}"))
  end
    
  def _assert_valid_weather_code (code)
    (((code >= 0) && (code <= 47)) || (code == 3200))
  end
  
  def _assert_valid_units (units, fahrenheit_based)
    assert_instance_of YahooWeather::Units, units
    if fahrenheit_based
      assert_equal units.temperature, 'F'
      assert_equal units.distance, 'mi'
      assert_equal units.pressure, 'in'
      assert_equal units.speed, 'mph'

    else
      assert_equal units.temperature, 'C'
      assert_equal units.distance, 'km'
      assert_equal units.pressure, 'mb'
      assert_equal units.speed, 'kph'
    end
  end
end
