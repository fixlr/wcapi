module WCAPI
  class GetRecordResponse 
    include WCAPI::XPath
    attr_accessor :record, :raw

    def initialize(doc)
      @raw = doc
      @record = {}
      parse_marcxml(doc)
    end

   def parse_marcxml(xml)
      begin
        require 'rexml/document'
        doc = REXML::Document.new(xml)
      rescue
 	      #likely some kind of xml error 
      end

      @record = parse_marcxml_record(xpath_first(doc, "/record"))
   end

  end
end
