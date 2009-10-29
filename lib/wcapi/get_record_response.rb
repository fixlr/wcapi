module WCAPI
  class GetRecordResponse 
    include WCAPI::XPath
    attr_accessor :record, :raw

    def initialize(doc)
      #super doc
      @raw = doc
      parse_marcxml(doc)
    end

   def parse_marcxml(xml)
      @record = {}
      
      begin
        require 'rexml/document'
        doc = REXML::Document.new(xml)
      rescue
 	      #likely some kind of xml error 
      end

      if node = xpath_first(doc, "/record")
        @record.merge(parse_marcxml_record(node))
      end
   end

  end
end
