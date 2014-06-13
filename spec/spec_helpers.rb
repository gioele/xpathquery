require 'rspec/collection_matchers'

RSpec.configure do |config|
	config.expect_with :rspec do |c|
		c.syntax = [:should, :expect]
	end
end

def fixture_file(name)
	return "spec/fixtures/#{name}.xml"
end

# This is free software released into the public domain (CC0 license).
