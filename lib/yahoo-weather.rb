# yahoo-weather -- provides OO access to the Yahoo! Weather RSS XML feed
# Copyright (C) 2006 Walter Korman <shaper@wgks.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require 'net/http'
require 'pp'
require 'time'
require 'xmlsimple'

class YahooWeather

  VERSION = '1.0.1'

  # Describes astronomy information for a particular location.
  class Astronomy
    # a Time object detailing the sunrise time for a location.
    attr_reader :sunrise
    
    # a Time object detailing the sunset time for a location.
    attr_reader :sunset
    
    def initialize (payload)
      @sunrise = YahooWeather._parse_time(payload['sunrise'])
      @sunset = YahooWeather._parse_time(payload['sunset'])
    end
  end

  # Describes a geographical location.
  class Location
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

  # Describes the units of measure with which weather information is provided.
  class Units
    # the units in which temperature is measured, e.g. +F+ for +Fahrenheit+ or +C+ for +Celsius+.
    attr_reader :temperature
    
    # the units in which distance is measured, e.g. +mi+ for +miles+.
    attr_reader :distance
    
    # the units in which pressure is measured, e.g. +in+ for +inches+.
    attr_reader :pressure
    
    # the units in which speed is measured, e.g. +mph+ for <tt>miles per hour</tt>.
    attr_reader :speed
    
    def initialize (payload)
      @temperature = payload['temperature']
      @distance = payload['distance']
      @pressure = payload['pressure']
      @speed = payload['speed']
    end
  end

  # Describes the specific wind conditions at a location.
  class Wind
    # the temperature factoring in wind chill.
    attr_reader :chill
    
    # the direction of the wind in degrees.
    attr_reader :direction
    
    # the speed of the wind.
    attr_reader :speed
    
    def initialize (payload)
      @chill = payload['chill'].to_i
      @direction = payload['direction'].to_i
      @speed = payload['speed'].to_i
    end
  end

  # Describes the specific atmospheric conditions at a location.
  class Atmosphere
    # the humidity of the surroundings.
    attr_reader :humidity
    
    # the visibility level of the surroundings
    attr_reader :visibility
    
    # the pressure level of the surroundings.
    attr_reader :pressure
    
    # whether the air currents are rising.
    attr_reader :rising
    
    def initialize (payload)
      @humidity = payload['humidity'].to_i
      @visibility = payload['visibility'].to_i
      @pressure = payload['pressure'].to_f
      @rising = (payload['rising'] == "1")
    end
  end
  
  class Condition
    # the Yahoo! Weather condition code, as detailed at http://developer.yahoo.com/weather.
    attr_reader :code
    
    # the date and time associated with these conditions.
    attr_reader :date
    
    # the temperature of the location.
    attr_reader :temp
    
    # the brief prose text description of the weather conditions of the location.
    attr_reader :text
    
    def initialize (payload)
      @code = payload['code'].to_i
      @date = YahooWeather._parse_time(payload['date'])
      @temp = payload['temp'].to_i
      @text = payload['text']
    end
  end

  # The forecasted weather conditions for a specific location.
  class Forecast
    # the brief name of the day associated with the forecast.
    attr_reader :day
    
    # the date associated with the forecast.
    attr_reader :date
    
    # the low temperature forecasted.
    attr_reader :low
    
    # the high temperature forecasted.
    attr_reader :high
    
    # the brief prose text description of the forecasted weather conditions.
    attr_reader :text
    
    # the Yahoo! Weather code associated with the forecast, per http://developer.yahoo.com/weather.
    attr_reader :code
    
    def initialize (payload)
      @day = payload['day']
      @date = YahooWeather._parse_time(payload['date'])
      @low = payload['low'].to_i
      @high = payload['high'].to_i
      @text = payload['text']
      @code = payload['code'].to_i
    end
  end

  # Describes the weather conditions for a particular requested location.
  class Response
    # a YahooWeather::Astronomy object detailing the sunrise and sunset
    # information for the requested location.
    attr_reader :astronomy

    # a YahooWeather::Location object detailing the precise geographical names
    # to which the requested location was mapped.
    attr_reader :location

    # a YahooWeather::Units object detailing the units corresponding to the
    # information detailed in the response.
    attr_reader :units

    # a YahooWeather::Wind object detailing the wind information at the
    # requested location.
    attr_reader :wind

    # a YahooWeather::Atmosphere object detailing the atmosphere information
    # of the requested location.
    attr_reader :atmosphere

    # a YahooWeather::Condition object detailing the current conditions of the
    # requested location.
    attr_reader :condition

    # a list of YahooWeather::Forecast objects detailing the high-level
    # forecasted weather conditions for upcoming days.
    attr_reader :forecasts

    # the raw HTML generated by the Yahoo! Weather service summarizing current
    # weather conditions for the requested location.
    attr_reader :description
    
    # a link to the Yahoo! Weather image icon representing the current weather
    # conditions visually.
    attr_reader :image_url
    
    # the latitude of the location for which weather is detailed.
    attr_reader :latitude

    # the longitude of the location for which weather is detailed.
    attr_reader :longitude
    
    # a link to the Yahoo! Weather page with full detailed information on the
    # requested location's current weather conditions.
    attr_reader :page_url

    # the location string initially requested of the service.
    attr_reader :request_location

    # the url with which the Yahoo! Weather service was accessed to build the response.
    attr_reader :request_url
    
    # the prose descriptive title of the weather information.
    attr_reader :title

    # regular expression used to pull the weather image icon from full
    # description text.
    @@REGEXP_IMAGE = Regexp.new(/img src="([^"]+)"/)

    def initialize (request_location, request_url, payload)
      @request_location = request_location
      @request_url = request_url

      root = payload['channel'].first
      @astronomy = YahooWeather::Astronomy.new root['astronomy'].first
      @location = YahooWeather::Location.new root['location'].first
      @units = YahooWeather::Units.new root['units'].first
      @wind = YahooWeather::Wind.new root['wind'].first
      @atmosphere = YahooWeather::Atmosphere.new root['atmosphere'].first

      item = root['item'].first
      @condition = YahooWeather::Condition.new item['condition'].first
      @forecasts = []
      item['forecast'].each { |forecast| @forecasts << YahooWeather::Forecast.new(forecast) }
      @latitude = item['lat'].first.to_f
      @longitude = item['long'].first.to_f
      @page_url = item['link'].first
      @title = item['title'].first
      @description = item['description'].first

      match_data = @@REGEXP_IMAGE.match(description)
      @image_url = (match_data) ? match_data[1] : nil
    end
  end

  # The main client object through which the Yahoo! Weather service may be accessed.
  class Client
    # the url with which we obtain weather information from yahoo
    @@API_URL = "http://xml.weather.yahoo.com/forecastrss"
  
    def initialize (api_url = @@API_URL)
      @api_url = api_url
    end

    # Returns a YahooWeather::Response object detailing the current weather
    # information for the specified location.
    #
    # +location+ can be either a US zip code or a location code.  Location
    # codes can be looked up at http://weather.yahoo.com, where it will appear
    # in the URL that results from searching on the city or zip code.  For
    # instance, searching on 'Seattle, WA' results in a URL ending in
    # 'USWA0395.html', so the location code for Seattle is 'USWA0395'.
    #
    # +units+ allows specifying whether to retrieve information in
    # +Fahrenheit+ as +f+, or +Celsius+ as +c+, and defaults to +f+.
    def lookup_location (location, units = 'f')
      # query the service to grab the xml data
      url = _request_url(location, units)
      begin
         response = Net::HTTP.get_response(URI.parse(url)).body.to_s
      rescue
        raise "failed to get weather via '#{url}': " + $!
      end

      # create the response object
      response = XmlSimple.xml_in(response)
      YahooWeather::Response.new(location, url, response)
    end
  
    private
    def _request_url (location, units)
      @api_url + '?p=' + URI.encode(location) + '&u=' + URI.encode(units)
    end
  end

  private
  def self._parse_time (text)
    (text) ? Time.parse(text) : nil
  end
end
