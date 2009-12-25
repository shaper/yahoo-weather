# The forecasted weather conditions for a specific location.
class YahooWeather::Forecast
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
