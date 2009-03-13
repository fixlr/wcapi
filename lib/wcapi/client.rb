require 'uri'
require 'net/http'
require 'cgi'

module WCAPI 

  # The WCAPI::Client object provides a public facing interface to interacting
  # with the various WorldCat API Grid Services. 
  #
  #   client = WCAPI::Client.new :query => 'query', :format => [atom|rss], :start => [position], :count => [max records], :cformat => [mla|apa], :wskey => [your world cat key
  # options:
  #    wskey
  #    xmlparser [by default, rexml, but libxml supported]
  #
  #
  # More information can be found at:
  #   http://worldcat.org/devnet/wiki/SearchAPIDetails  
  
  class Client

    # The constructor which must be passed a valid base url for an oai 
    # service:
    #
    # If you want to see debugging messages on STDERR use:
    # :debug => true
    
    def initialize(options={})
      @debug = options[:debug]
      #if defined?(options[:xmlparser]: 
      #	 @xmlparser = options[:xmlparser]
      #else
      #	 @xmlparser = 'rexml'
      #end
      @wskey = options[:wskey]
    end

    # Equivalent to a Identify request. You'll get back a OAI::IdentifyResponse
    # object which is essentially just a wrapper around a REXML::Document 
    # for the response.
    
    def OpenSearch(opts={}) 
      @base = URI.parse WORLDCAT_OPENSEARCH
      opts["wskey"] = @wskey
      xml = do_request(opts)
      return OpenSearchResponse.new(xml)
    end

    def GetRecord(opts={})
      if opts[:type] == 'oclc'
         @base = URI.parse "http://www.worldcat.org/webservices/catalog/content/" + opts[:id]
      else
	 @base = URI.parse 'http://www.worldcat.org/webservices/catalog/content/isbn/' + opts[:id]
      end
      opts.delete("type")
      opts["wskey"] = @wskey
      xml = do_request(opts)
      return GetRecordResponse.new(xml)
    end


    def GetLocations(opts={})
       if opts[:type] == 'oclc'
         @base = URI.parse "http://www.worldcat.org/webservices/catalog/content/libraries/" + opts[:id]
      else
         @base = URI.parse 'http://www.worldcat.org/webservices/catalog/content/libraries/isbn/' + opts[:id]
      end
      opts.delete("type")
      opts["wskey"] = @wskey
      xml = do_request(opts)
      return GetLocationResponse.new(xml)
    end    

    def GetCitation(opts = {})
     if opts[:type] == 'oclc'
         @base = URI.parse "http://www.worldcat.org/webservices/catalog/content/citations/" + opts[:id]
      else
         @base = URI.parse 'http://www.worldcat.org/webservices/catalog/content/citations/isbn/' + opts[:id]
      end
      opts.delete("type")
      opts["wskey"] = @wskey
      xml = do_request(opts)
      #Returns an HTML representation
      return xml
    end

    def SRUSearch(opts={})
      @base = URI.parse WORLDCAT_SRU
      opts["wskey"] = @wskey
      xml = do_request(opts)
      return SruSearchResponse.new(xml)
    end


    private 

    def do_request(hash)
      uri = @base.clone

      # build up the query string
      parts = hash.entries.map do |entry|
        key = studly(entry[0].to_s)
        value = entry[1]
        value = CGI.escape(entry[1].to_s)
        "#{key}=#{value}"
      end
      uri.query = parts.join('&')
      debug("doing request: #{uri.to_s}")

      # fire off the request and return an REXML::Document object
      begin
        xml = Net::HTTP.get(uri)
        debug("got response: #{xml}")
	return xml
      rescue SystemCallError=> e
        #raise WCAPI::Exception, 'HTTP level error during WCAPI  request: '+e, caller
      end
    end

    # convert foo_bar to fooBar thus allowing our ruby code to use
    # the typical underscore idiom
    def studly(s)
      s.gsub(/_(\w)/) do |match|
        match.sub! '_', ''
        match.upcase
      end
    end

    def debug(msg)
      $stderr.print("#{msg}\n") if @debug
    end

     def to_h(default=nil)
        Hash[ *inject([]) { |a, value| a.push value, default || yield(value) } ]
     end

  end
end
