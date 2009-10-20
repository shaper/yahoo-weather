#!/usr/bin/env ruby
#
# Simple example script demonstrating usage of the yahoo-weather library.
#
# 2006/11/05 - Walter Korman (shaper@wgks.org)
#

require 'rubygems'
require 'pp'
require 'yahoo-weather'

location = ARGV[0]
if !location
  STDERR.print "Usage: get-weather.rb <zip code>\n"
  exit
end

print "Looking up weather for #{location}...\n"
@client = YahooWeather::Client.new
response = @client.lookup_location(location)
pp(response)
