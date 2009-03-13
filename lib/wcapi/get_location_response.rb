module WCAPI
  class GetLocationResponse 
    include WCAPI::XPath
    attr_accessor :institutions, :raw

    def initialize(doc)
      #super doc
      @raw = doc
      parse_holdings(doc)
    end

   def parse_holdings(xml)
      _oclc_symbol = ""
      _link = ""
      _copies = ""
      _xml = xml
      _instchash = {}
      _records = Array.new()
      _x = 0

      begin
        require 'xml/libxml'
        _parser = LibXML::XML::Parser.new()
        _parser.string = xml
        doc = LibXML::XML::Document.new()
        doc = _parser.parse
      rescue
        begin
           require 'rexml/document'
           doc = REXML::Document.new(xml)
        rescue
           #likely some kind of xml error
        end
      end

      nodes = xpath_all(doc, "//holding")
      nodes.each { |item |
         _oclc_symbol = xpath_get_text(xpath_first(item, "institutionIdentifier/value")) 

         if xpath_first(item, "electronicAddress/text") != nil 
           _link = xpath_get_text(xpath_first(item, "electronicAddress/text")) 
         end

         if xpath_first(item, "holdingSimple/copiesSummary/copiesCount") != nil
	    _copies = xpath_get_text(xpath_first(item, "holdingSimple/copiesSummary/copiesCount"))
	 end

         _instchash = {:institutionIdentifier => _oclc_symbol, :link => _link, :copies => _copies ,
		     :xml => item.to_s}
	_records.push(_instchash)
      }
      @institutions = _records
   end

  end
end
