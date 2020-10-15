require './lib/oktags'
require './lib/ok/version'

GEM_NAME = 'oktags'
GEM_VERSION = OK::Tags::VERSION

task default: :build

task :build do
  system 'gem build ' + GEM_NAME + '.gemspec'
end

task install: :build do
  system 'gem install ' + GEM_NAME + '-' + GEM_VERSION + '.gem'
end

task publish: :build do
  system 'gem push ' + GEM_NAME + '-' + GEM_VERSION + '.gem'
end

task :clean do
  system 'rm *.gem'
end
