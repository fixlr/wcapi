module WCAPI
  class Holding
    include WCAPI::ResponseParser
    attr_accessor :doc
    
    def initialize(xml)
      @doc = xml
    end
    
    def id
      xpath_get_text(xpath_first(@doc, "holding/institutionIdentifier/value"))
    end
    
    def type
      xpath_get_text(xpath_first(@doc, "holding/institutionIdentifier/typeOrSource/pointer"))
    end
    
    def location
      xpath_get_text(xpath_first(@doc, "holding/physicalLocation"))
    end
    
    def address
      xpath_get_text(xpath_first(@doc, "holding/physicalAddress/text"))
    end
    
    def url
      xpath_get_text(xpath_first(@doc, "holding/electronicAddress/text"))
    end
    
    def copies
      "#{xpath_get_text(xpath_first(@doc, "holding/holdingSimple/copiesSummary/copiesCount"))}".to_i
    end
  end
end