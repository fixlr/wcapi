require 'rexml/document'

module WCAPI
  class GetRecordResponse 
    include WCAPI::ResponseParser
    
    attr_accessor :record, :raw

    def initialize(xml='')
      @raw = xml
      @record = {}

      @record = (xml == '') ? WCAPI::Record.new : parse_marcxml(xml)
    end

    def parse_marcxml(xml)
      doc = get_parser(xml)
      record = WCAPI::Record.new(xpath_first(doc, "/record"))
      (record.doc.nil?) ? nil : record
   end
  end
end
