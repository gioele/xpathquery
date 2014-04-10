require 'xpathquery/error'

module XPathQuery
	class Engine
		def initialize(db_url, logger = nil)
			@db_url = db_url
			@logger = logger
		end

		def query(q, ns = nil)
			ns ||= {}

			begin
				results = perform_query(q, ns)
			rescue Exception
				raise XPathQuery::Error.new(@db_url, q)
			end

			return results
		end
	end
end

# This is free software released into the public domain (CC0 license).
