require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = 'yahoo-weather'
  s.version = '1.0.0'
  s.summary = 'A Ruby object-oriented interface to the Yahoo! Weather service.'
  s.author = 'Walter Korman'
  s.email = 'shaper@wgks.org'
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = 'yahoo-weather'
  s.has_rdoc = true
  s.extra_rdoc_files = [ 'README' ]
  s.rdoc_options << '--main' << 'README'
  s.test_files = Dir.glob('test/test_*.rb')  
  s.files = Dir.glob("{examples,lib,test}/**/*") +
    [ 'AUTHORS', 'CHANGELOG', 'LICENSE', 'README', 'Rakefile', 'TODO' ]
  s.add_dependency("xml-simple", ">= 1.0.9")
end

desc 'Run tests'
task :default => [ :test ]

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end

desc 'Generate RDoc'
Rake::RDocTask.new :rdoc do |rd|
  rd.rdoc_dir = 'doc'
  rd.rdoc_files.add 'lib', 'README'
  rd.main = 'README'
end

desc 'Build Gem'
Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = true
end

desc 'Clean up'
task :clean => [ :clobber_rdoc, :clobber_package ]

desc 'Clean up'
task :clobber => [ :clean ]
