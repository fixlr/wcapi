require 'rubygems'
spec = Gem::Specification.new do |s|
    s.name = 'wcapi'
    s.version = '0.0.1'
    s.author = 'Terry Reese'
    s.email = 'terry.reese@oregonstate.edu'
    s.platform = Gem::Platform::RUBY
    s.summary = 'Ruby component for processing the WorldCat API'
    s.files = Dir.glob("{lib}/**/*")
    s.require_path = 'lib'
    s.has_rdoc = false
    s.test_file = 'test.rb'
end

if $0 == __FILE__
    Gem::manage_gems
    Gem::Builder.new(spec).build
end

