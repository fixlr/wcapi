module WCAPI
  class GetLocationResponse 
    include WCAPI::ResponseParser
    attr_accessor :locations, :raw

    def initialize(xml='')
      @raw = xml
      @locations = []
      parse_holdings(xml) unless @raw == ''
    end

    def parse_holdings(xml)
      doc = get_parser(xml)

      nodes = xpath_all(doc, "//holding")
      @locations = nodes.collect do |holding|
        WCAPI::Holding.new(holding)
      end
    end
  end
end
