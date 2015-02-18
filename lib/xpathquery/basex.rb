require 'nokogiri'

begin
	require 'rest-client'
rescue Exception
	warn "The 'rest-client' gem must be installed in order to use XPathQuery::BaseX."
	raise
end

require 'xpathquery/engine'
require 'xpathquery/error'

module XPathQuery
	class BaseX < Engine
		NS = {
			'basex' => 'http://basex.org/rest',
		}

		def perform_query(q, ns)
			if @max_results != :unlimited
				raise "Limits on the returned results are unimplemented"
			end

			db = RestClient::Resource.new(@db_url)

			query_message = query_message(q, ns)

			opts = {
				:content_type => 'application/xml'
			}

			start_time = nil
			@logger and @logger.debug { start_time = Time.now; "Connecting to <#{@db_url}> to send the query:\n#{query_message}" }

			response = db.post(query_message, opts)

			end_time = nil
			@logger and @logger.debug { end_time = Time.now; diff = (end_time.to_f - start_time.to_f) * 1000; "received XML response (in #{diff.round} ms):\n#{response.split("\n").first(10).join("\n")}" }

			xml_response = ::Nokogiri::XML(response)

			wrapped_results = xml_response.xpath('/basex:results/*', NS)
			results = wrapped_results.map(&:first_element_child)

			if results.count == 1 && results.first.nil?
				results = [wrapped_results.first.text]
			end

			return results
		end

		def query_message(query, ns)
			ns_decls = ns.merge(NS).map { |name, uri| "declare namespace #{name}='#{uri}';" }.join("\n")

			# FIXME: build once using Nokogiri and then cache
			message =<<EOD
<basex:query xmlns:basex="#{NS['basex']}">
	<basex:text><![CDATA[
		#{ns_decls}

		let $results := ( #{query} ) ! element basex:result { . }

		return <basex:results>{$results}</basex:results>
	]]></basex:text>
</basex:query>
EOD
			return message
		end

		class BaseXError
			def initialize(response)
				@response = response
			end

			attr_reader :response

			def message
				return @response.to_s
			end
		end
	end
end

# This is free software released into the public domain (CC0 license).
