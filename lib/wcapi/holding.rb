module WCAPI
  class Holding
    include WCAPI::ResponseParser
    attr_accessor :doc
    
    def initialize(xml)
      @doc = xml
    end
    
    def code
      xpath_get_text(xpath_first(@doc, "institutionIdentifier/value"))
    end
    
    def type
      xpath_get_text(xpath_first(@doc, "institutionIdentifier/typeOrSource/pointer"))
    end
    
    def location
      xpath_get_text(xpath_first(@doc, "physicalLocation"))
    end
    
    def address
      xpath_get_text(xpath_first(@doc, "physicalAddress/text"))
    end
    
    def url
      xpath_get_text(xpath_first(@doc, "electronicAddress/text"))
    end
    
    def copies
      "#{xpath_get_text(xpath_first(@doc, "holdingSimple/copiesSummary/copiesCount"))}".to_i
    end
  end
end