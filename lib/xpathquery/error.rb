module XPathQuery
	class Error < Exception
		def initialize(db_url, query, response = nil)
			@db_url = db_url
			@query = query
			@response = response
		end

		attr_reader :query
		attr_reader :response

		def message
			"Error while querying <#{@db_url}>"
		end
	end
end

# This is free software released into the public domain (CC0 license).
