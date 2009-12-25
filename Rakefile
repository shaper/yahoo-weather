require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'yahoo-weather'

Hoe.spec('yahoo-weather') do |p|
  self.version = YahooWeather::VERSION
  self.rubyforge_name = 'yahoo-weather'
  self.author = 'Walter Korman'
  self.email = 'shaper@fatgoose.com'
  self.extra_deps << [ 'nokogiri', '>= 1.4.1' ]
  self.summary = 'A Ruby object-oriented interface to the Yahoo! Weather service.'
  self.description = <<EDOC
The yahoo-weather rubygem provides a Ruby object-oriented interface to the
Yahoo! Weather service described in detail at:

http://developer.yahoo.com/weather
EDOC
  self.url = 'http://rubyforge.org/projects/yahoo-weather'
  self.remote_rdoc_dir = '' # Release to root
  self.readme_file = 'README.rdoc'
  self.history_file = 'CHANGELOG.rdoc'
  self.extra_rdoc_files = [ 'CHANGELOG.rdoc', 'README.rdoc' ]
end
