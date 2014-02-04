Gem::Specification.new do |s|
  s.name = 'yahoo-weather'
  s.version = '1.2.1'
  s.summary = 'A Ruby object-oriented interface to the Yahoo! Weather service'
  s.description = "The yahoo-weather rubygem provides a Ruby object-oriented interface to the Yahoo! Weather service described in detail at: http://developer.yahoo.com/weather"

  s.add_dependency('nokogiri', '>= 1.4.1')
  s.add_dependency('hoe',   '>= 2.4.0')

  s.rdoc_options << '--exclude' << '.'

  s.files = Dir['CHANGELOG.rdoc', 'README', 'Manifest.txt', 'Rakefile', 'TODO', 'examples/*', 'lib/**', 'lib/**/**', 'test/**']
  s.require_path = 'lib'
  s.test_file = 'test/test_api.rb'

  s.author = "Walter Korman"
  s.email = "shaper@fatgoose.com"
  s.homepage = "http://rubyforge.org/projects/yahoo-weather"
end
