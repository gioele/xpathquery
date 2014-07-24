require 'spec_helpers'

require 'xpathquery/nokogiri'

describe XPathQuery::Nokogiri do
	describe "#query" do
		let(:nokogiri) { XPathQuery::Nokogiri.new(fixture_file(:library)) }

		it "works for simple queries" do
			results = nokogiri.query('//book')
			results.should have(3).items
		end

		it "takes namespaces into account" do
			ns = { 'foaf' => 'http://xmlns.com/foaf/0.1/' }
			results = nokogiri.query('//patron/foaf:name', [], ns)
			results.should have(2).items
			results.map { |n| n.text }.should == ["Mel Petit", "Bertrand Müller"]
		end

		it "may return no results" do
			results = nokogiri.query('//loan[not(@date)]')
			results.should be_empty
		end

		it "raises an error when the there is a problem with the XML file" do
			nokogiri = XPathQuery::Nokogiri.new(fixture_file(:non_existing))
			expect { nokogiri.query('//*') }.to raise_error(/non_existing/)
		end

		it "accepts parameters" do
			params = { :patron_id => 'p1' }
			results = nokogiri.query('//patron[@xml:id="%{patron_id}"]', params)
			results.should have(1).items
		end
	end

	describe "#direct_query" do
		let(:nokogiri) { XPathQuery::Nokogiri.new(fixture_file(:library)) }

		it "works for simple queries" do
			results = nokogiri.direct_query('//book')
			results.should have(3).items
		end

		it "takes namespaces into account" do
			ns = { 'foaf' => 'http://xmlns.com/foaf/0.1/' }
			results = nokogiri.direct_query('//patron/foaf:name', ns)
			results.should have(2).items
			results.map { |n| n.text }.should == ["Mel Petit", "Bertrand Müller"]
		end

		it "may return no results" do
			results = nokogiri.direct_query('//loan[not(@date)]')
			results.should be_empty
		end

		it "raises an error when the there is a problem with the XML file" do
			nokogiri = XPathQuery::Nokogiri.new(fixture_file(:non_existing))
			expect { nokogiri.direct_query('//*') }.to raise_error(/non_existing/)
		end
	end
end

# This is free software released into the public domain (CC0 license).
