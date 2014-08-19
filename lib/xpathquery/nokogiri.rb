require 'nokogiri'

require 'xpathquery/engine'

module XPathQuery
	class Nokogiri < Engine
		def perform_query(q, ns)
			results = []

			@xml ||= ::Nokogiri::XML(open(@db_url))

			results = @xml.xpath(q, ns)
			results = Array(results)

			if @max_results != :unlimited
				results = results[0..(@max_results-1)]
			end

			return results
		end
	end
end

# This is free software released into the public domain (CC0 license).
