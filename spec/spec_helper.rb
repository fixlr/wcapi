require 'rubygems'
require 'spec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/wcapi')

Spec::Runner.configure do |config|
  config.mock_with :mocha
end