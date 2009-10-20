#!/usr/bin/env ruby

require 'rubygems'
require 'yahoo-weather'

@client = YahooWeather::Client.new
response = @client.lookup_location('98103')

# straight text output
print <<edoc
#{response.title}
#{response.condition.temp} degrees #{response.units.temperature}
#{response.condition.text}
edoc

# html output
print <<edoc
<div>
  <img src="#{response.image_url}"><br/>
  #{response.condition.temp} degrees #{response.units.temperature}<br/>
  #{response.condition.text}<br>
  Forecast:<br/>
  #{response.forecasts[0].day} - #{response.forecasts[0].text}.  High: #{response.forecasts[0].high} Low: #{response.forecasts[0].low}<br/>
  #{response.forecasts[1].day} - #{response.forecasts[1].text}.  High: #{response.forecasts[1].high} Low: #{response.forecasts[1].low}<br/>
  More information <a href="#{response.page_url}">here</a>.
</div>
edoc
