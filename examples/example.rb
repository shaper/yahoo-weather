#!/usr/bin/env ruby

require 'rubygems'
require 'yahoo-weather'

@client = YahooWeather::Client.new
# look up WOEID via http://weather.yahoo.com; enter location by city
# name or zip and WOEID is at end of resulting page url.  herein we use
# the WOEID for Santa Monica, CA.
response = @client.lookup_by_woeid(2488892)

# straight text output
print <<EDOC
#{response.title}
#{response.condition.temp} degrees
#{response.condition.text}
EDOC

# sample html output
print <<EDOC
<div>
  <img src="#{response.image.url}"><br/>
  #{response.condition.temp} degrees #{response.units.temperature}<br/>
  #{response.condition.text}<br>
  Forecast:<br/>
  #{response.forecasts[0].day} - #{response.forecasts[0].text}.  High: #{response.forecasts[0].high} Low: #{response.forecasts[0].low}<br/>
  #{response.forecasts[1].day} - #{response.forecasts[1].text}.  High: #{response.forecasts[1].high} Low: #{response.forecasts[1].low}<br/>
  More information <a href="#{response.page_url}">here</a>.
</div>
EDOC
