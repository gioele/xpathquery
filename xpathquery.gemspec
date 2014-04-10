# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xpathquery/version'

Gem::Specification.new do |spec|
	spec.name          = "xpathquery"
	spec.version       = XPathQuery::VERSION
	spec.authors       = ["Gioele Barabucci"]
	spec.email         = ["gioele@svario.it"]
	spec.description   = %q{TODO: Write a gem description}
	spec.summary       = %q{TODO: Write a gem summary}
	spec.homepage      = "http://svario.it/xpathquery"
	spec.license       = "CC0"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_dependency 'nokogiri'

	spec.add_development_dependency 'bundler', '~> 1.5'
	spec.add_development_dependency 'rake'
	spec.add_development_dependency 'rspec'
end

# This is free software released into the public domain (CC0 license).
