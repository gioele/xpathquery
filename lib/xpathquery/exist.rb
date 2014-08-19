require 'nokogiri'

begin
	require 'rest_client'
rescue Exception
	warn "The 'rest_client' gem must be installed in order to use XPathQuery::Exist."
	raise
end

require 'xpathquery/engine'
require 'xpathquery/error'

module XPathQuery
	class Exist < Engine
		NS = {
			'exist' => 'http://exist.sourceforge.net/NS/exist',
		}

		UNLIMITED_RESULTS_ATTR = "max='999999'"

		def perform_query(q, ns)
			db = RestClient::Resource.new(@db_url)

			query_message = query_message(q, ns)
			@logger and @logger.debug { "connecting to <#{@db_url}> to send the query #{query_message}" }

			opts = {
				:content_type => 'application/xml'
			}

			response = db.post(query_message, opts)

			@logger and @logger.debug { "received XML response\n#{response}" }

			xml_response = ::Nokogiri::XML(response)

			# TODO: see rest_client HTTP error code handling
			if xml_response.root.name == 'exception'
				message = xml_response.xpath('//message')[0].text()
				raise ExistError.new(message)
			end

			results = xml_response.xpath('/exist:result/*', NS)

			if results.count == 1 && results.first.name == 'value'
				results = [results.first.text]
			end

			return results
		end

		def query_message(query, ns)
			ns_attrs = ns.map { |name, uri| "xmlns:#{name}='#{uri}'" }.join(" ")

			# FIXME: sanitize query parameters
			query_escaped = query.gsub('&', '&amp;').gsub('<', '&lt;')

			if @max_results == :unlimited
				limits_attr = UNLIMITED_RESULTS_ATTR
			else
				limits_attr = "max='#{@max_results}'"
			end

			# FIXME: build once using Nokogiri and then cache
			message =<<EOD
<query xmlns="http://exist.sourceforge.net/NS/exist" #{ns_attrs} #{limits_attr}>
	<text>#{query_escaped}</text>
</query>
EOD
			return message
		end

		class ExistError
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
