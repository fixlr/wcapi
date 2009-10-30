module WCAPI
  class SruSearchResponse
    include WCAPI::ResponseParser

    attr_accessor :header, :records, :raw

    def initialize(xml='')
      @raw = xml
      @records = []
      @header  = {}
      parse_marcxml(xml) unless @raw == ''
    end

   def parse_marcxml(xml)
      xml = xml.gsub('<?xml-stylesheet type="text/xsl" href="/webservices/catalog/xsl/searchRetrieveResponse.xsl"?>', "")
      doc = get_parser(xml)
      
      @header["numberOfRecords"] = xpath_get_text(xpath_first(doc, "//numberOfRecords")).to_i
      @header["recordSchema"] = xpath_get_text(xpath_first(doc, "//recordSchema"))
      @header["nextRecordPosition"] = xpath_get_text(xpath_first(doc, "//nextRecordPosition")).to_i
      @header["maximumRecords"] = xpath_get_text(xpath_first(doc, "//maximumRecords")).to_i
      @header["startRecord"] = xpath_get_text(xpath_first(doc, "//startRecord")).to_i
 
      nodes = xpath_all(doc, "//records/record/recordData/record")
      nodes.each do |item|
	      @records << WCAPI::Record.new(item)
      end
   end

  end
end
