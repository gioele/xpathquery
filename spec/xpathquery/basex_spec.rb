require 'spec_helpers'

require 'xpathquery/basex'

describe XPathQuery::BaseX, :needs_server => true do
	describe "#query" do
		let(:basex) { XPathQuery::BaseX.new('http://localhost:8984/rest/library') }

		it "works for simple queries" do
			results = basex.query('//book')
			results.should have(3).items
		end

		it "takes namespaces into account" do
			ns = { 'foaf' => 'http://xmlns.com/foaf/0.1/' }
			results = basex.query('//patron/foaf:name', [], ns)
			results.should have(2).items
			results.map { |n| n.text }.should == ["Mel Petit", "Bertrand Müller"]
		end

		it "returns atomic values" do
			results = basex.query('string(//patron[1]/*)')
			results.should have(1).item
			results.first.should == "Mel Petit"
		end

		it "may return no results" do
			results = basex.query('//loan[not(@date)]')
			results.should be_empty
		end

		it "raises an error when the XPath query is malformed" do
			expect { basex.query('//*()[') }.to raise_error
		end

		it "raises an error when the there is a problem with the XML file" do
			basex = XPathQuery::BaseX.new('http://localhost:8984/rest/non_existing')
			expect { basex.query('//*') }.to raise_error(/non_existing/)
		end

		it "accepts parameters" do
			params = { :patron_id => 'p1' }
			results = basex.query('//patron[@xml:id="%{patron_id}"]', params)
			results.should have(1).items
		end

		it "does not return more than max_results results" do
			basex = XPathQuery::BaseX.new('http://localhost:8984/rest/library', :max_results => 2)
			results = basex.query('//book')
			results.should have(2).items
		end
	end

	describe "#direct_query" do
		let(:basex) { XPathQuery::BaseX.new('http://localhost:8984/rest/library') }

		it "works for simple queries" do
			results = basex.direct_query('//book')
			results.should have(3).items
		end

		it "takes namespaces into account" do
			ns = { 'foaf' => 'http://xmlns.com/foaf/0.1/' }
			results = basex.direct_query('//patron/foaf:name', ns)
			results.should have(2).items
			results.map { |n| n.text }.should == ["Mel Petit", "Bertrand Müller"]
		end

		it "may return no results" do
			results = basex.direct_query('//loan[not(@date)]')
			results.should be_empty
		end

		it "raises an error when the XPath query is malformed" do
			expect { basex.direct_query('//*()[') }.to raise_error
		end

		it "raises an error when the there is a problem with the XML file" do
			basex = XPathQuery::BaseX.new('http://localhost:8984/rest/non_existing')
			expect { basex.direct_query('//*') }.to raise_error(/non_existing/)
		end
	end
end

# This is free software released into the public domain (CC0 license).
