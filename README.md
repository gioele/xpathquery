XPathQuery: query (remote) XML documents with XPath
==================================================

XPathQuery makes is easy to make queries on XML documents using various
engines. Right now [eXist-db](http://exist-db.org) and Nokogiri are supported.


Examples
--------

The main use of XPathQuery is to query remote XML databases without dealing
with the details such as request envelopes, deserialization and so on.

    # first we set up the query engine
    require 'xpathquery/exist'
    xml_remote = XPathQuery::Exist.new('http://localhost:8080/exist/rest/db')

    # then we perform the query and we get back an array of XML nodes
    results = xml_remote.query('//patron')
    results.map { |result| p result.class }
    # => [Nokogiri::XML::Element, Nokogiri::XML::Element, ...]

Namespaces are supported and are simple to use

    ns = { 'foaf' => 'http://xmlns.com/foaf/0.1/' }
    results = nokogiri.query('//foaf:name', ns)


Rails logger integration
------------------------

If a logger is supplied during the engine initialization it will be used
to log the queries made and the results received.

The Rails logger can be easily integrated passing `Rails.logger` to the
engine constructor.

    xml = XPathQuery::Exist.new('http://localhost:8080/...', Rails.logger)

The messages will be logged at the `:debug` level.


Requirements
------------

The `xpathquery` gem depends on the `nokogiri` gem, even when the Nokogiri
engine is not used.

Additionally, the eXist-db backend depends on the `rest_client` gem. If
you want to use the eXist-db backend you must install the `rest_client` gem,
bacuse it is not a direct dependency of the `xpathquery` and RubyGems does
not have the concept of "optional dependency".

This gem requires a modern Ruby implementation as MRI 2.1, JRuby or Rubinious.


Install
-------

    gem install xpathquery


Author
------

* Gioele Barabucci <http://svario.it/gioele> (initial author)


Development
-----------

Code
: <http://svario.it/xpathquery/ruby> (redirects to GitHub)

Report issues
: <http://svario.it/xpathquery/issues>

Documentation
: <http://svario.it/xpathquery/docs>


License
-------

This is free software released into the public domain (CC0 license).

See the `COPYING` file or <http://creativecommons.org/publicdomain/zero/1.0/>
for more details.
