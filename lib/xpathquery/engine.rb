require 'xpathquery/error'

module XPathQuery
	class Engine
		def initialize(db_url, options = {})
			@db_url = db_url
			@logger = options[:logger]
			@max_results = options[:max_results] || :unlimited
		end

		def query(q, params = nil, ns = nil)
			params ||= []

			@logger and @logger.debug { "Executing query <#{q}> with params #{params.inspect}" }

			query = apply_params(q, params)

			return direct_query(query, ns)
		end

		def direct_query(q, ns = nil)
			ns ||= {}

			begin
				results = perform_query(q, ns)
			rescue Exception => ex
				raise XPathQuery::Error.new(@db_url, q)
			end

			return results
		end

		def apply_params(template, params)
			query = template % params
			return query
		end
	end
end

# This is free software released into the public domain (CC0 license).
