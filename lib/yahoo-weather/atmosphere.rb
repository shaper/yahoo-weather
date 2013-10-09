# Describes the specific atmospheric conditions at a location.
class YahooWeather::Atmosphere
  # Constants representing the state of the barometric pressure.
  #
  class Barometer
    STEADY = 'steady'
    RISING = 'rising'
    FALLING = 'falling'

    # lists all possible barometer constants
    ALL = [ STEADY, RISING, FALLING ]
  end

  # the humidity of the surroundings.
  attr_reader :humidity

  # the visibility level of the surroundings
  attr_reader :visibility

  # the pressure level of the surroundings.
  attr_reader :pressure

  # the state of the barometer, defined as one of the
  # YahooWeather::Atmosphere::Barometer constants.
  attr_reader :barometer

  def initialize (payload)
    @humidity = payload['humidity'].to_i
    @visibility = payload['visibility'].to_i
    @pressure = payload['pressure'].to_f

    # map barometric pressure direction to appropriate constant
    @barometer = nil

    @barometer = case payload['rising'].to_i
    when 0 then Barometer::STEADY
    when 1 then Barometer::RISING
    when 2 then Barometer::FALLING
    end
  end
end
