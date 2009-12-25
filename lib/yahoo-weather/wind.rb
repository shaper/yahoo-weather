# Describes the specific wind conditions at a location.
class YahooWeather::Wind
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
