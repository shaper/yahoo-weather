# Describes the units of measure with which weather information is provided.
class YahooWeather::Units
  FAHRENHEIT = 'f'
  CELSIUS = 'c'

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
