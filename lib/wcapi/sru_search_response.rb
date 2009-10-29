module WCAPI
  class SruSearchResponse 
    include WCAPI::XPath
    attr_accessor :header, :records, :raw

    def initialize(xml)
      @raw = doc
      @records = []
      @header  = {}
      parse_marcxml(xml)
    end

   def parse_marcxml(xml)
      xml = xml.gsub('<?xml-stylesheet type="text/xsl" href="/webservices/catalog/xsl/searchRetrieveResponse.xsl"?>', "")

      begin
         require 'rexml/document'
         doc = REXML::Document.new(xml)
      rescue
         #likely some kind of xml error
      end

      @header["numberOfRecords"] = xpath_get_text(xpath_first(doc, "//numberOfRecords"))
      @header["recordSchema"] = xpath_get_text(xpath_first(doc, "//recordSchema"))
      @header["nextRecordPosition"] = xpath_get_text(xpath_first(doc, "//nextRecordPosition"))
      @header["maxiumumRecords"] = xpath_get_text(xpath_first(doc, "//maximumRecords"))
      @header["startRecord"] = xpath_get_text(xpath_first(doc, "//startRecord"))
 
      nodes = xpath_all(doc, "//records/record/recordData/record")
      nodes.each do |item|
	      @records << parse_marcxml_record(item)
      end
   end

  end
end
