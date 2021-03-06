module WCAPI 
  # The WCAPI::Client object provides a public facing interface to interacting
  # with the various WorldCat API Grid Services. 
  #
  #   client = WCAPI::Client.new :wskey => [your world cat key]
  #
  # More information can be found at:
  #   http://worldcat.org/devnet/wiki/SearchAPIDetails  
  
  class Client
    # If you want to see debugging messages on STDERR use:
    # :debug => true
    
    def initialize(options={})
      @debug  = options[:debug]
      @wskey  = options[:wskey]
    end

    def OpenSearch(opts={}) 
      @base = URI.parse WORLDCAT_OPENSEARCH
      xml = do_request(opts)
      return OpenSearchResponse.new(xml)
    end

    def GetRecord(opts={})
      if opts[:type] == 'oclc'
        @base = URI.parse WORLDCAT_GETRECORD + opts[:id]
      else
	      @base = URI.parse WORLDCAT_GETRECORD_ISBN + opts[:id]
      end
      opts.delete(:type)
      opts.delete(:id)
      xml = do_request(opts)
      return GetRecordResponse.new(xml)
    end

    def GetLocations(opts={})
       if opts[:type] == 'oclc'
         @base = URI.parse WORLDCAT_GETLOCATION + opts[:id]
      else
         @base = URI.parse WORLDCAT_GETLOCATION_ISBN + opts[:id]
      end
      opts.delete(:type)
      opts.delete(:id)
      xml = do_request(opts)
      return GetLocationResponse.new(xml)
    end    

    def GetCitation(opts = {})
     if opts[:type] == 'oclc'
         @base = URI.parse WORLDCAT_GETCITATION + opts[:id]
      else
         @base = URI.parse WORLDCAT_GETCITATION_ISBN + opts[:id]
      end
      opts.delete(:type)
      opts.delete(:id)
      do_request(opts) # Returns an HTML representation
    end

    def SRUSearch(opts={})
      @base = URI.parse WORLDCAT_SRU
      xml = do_request(opts)
      return SruSearchResponse.new(xml)
    end

    private 

    def do_request(hash)
      uri = @base.clone

      hash["wskey"] = @wskey

      # build up the query string
      parts = hash.entries.map do |entry|
        key = studly(entry[0].to_s)
        value = entry[1]
        value = CGI.escape(entry[1].to_s)
        "#{key}=#{value}"
      end
      uri.query = parts.join('&')
      debug("doing request: #{uri.to_s}")

      # fire off the request and return the XML
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
