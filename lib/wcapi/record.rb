module WCAPI
  class Record
    include WCAPI::ResponseParser
    attr_accessor :doc
    
    def initialize(doc = '')
       @doc = doc
    end
    
    def oclc_id
      @id ||= xpath_get_text(xpath_first(@doc, "controlfield[@tag='001']"))
    end
    
    def isbns
      unless @isbns
        @isbns = []
        xpath_all(@doc, "datafield[@tag='020']/subfield[@code='a']").each do |i|
          @isbns << xpath_get_text(i)
        end
      end
      return @isbns
    end

    def link
      "http://www.worldcat.org/oclc/#{self.oclc_id}"
    end

    def title
      unless @title
        @title = []
        xpath_all(@doc, "datafield[@tag='245']/subfield[@code='a']").each do |i|
          @title << xpath_get_text(i)
        end
        xpath_all(@doc, "datafield[@tag='245']/subfield[@code='b']").each do |i|
          @title << xpath_get_text(i)
        end
      end
      return @title
    end
    
    def authors
      unless @authors
        @authors = []
        xpath_all(@doc, "datafield[@tag='100']/subfield[@code='a']").each do |i|
          @authors << xpath_get_text(i)
        end
        xpath_all(@doc, "datafield[@tag='110']/subfield[@code='a']").each do |i|
          @authors << xpath_get_text(i)
        end
        xpath_all(@doc, "datafield[@tag='111']/subfield[@code='a']").each do |i|
          @authors << xpath_get_text(i)
        end

        xpath_all(@doc, "datafield[@tag='700']/subfield[@code='a']").each do |i|
          @authors << xpath_get_text(i)
        end
        xpath_all(@doc, "datafield[@tag='710']/subfield[@code='a']").each do |i|
          @authors << xpath_get_text(i)
        end
        xpath_all(@doc, "datafield[@tag='711']/subfield[@code='a']").each do |i|
          @authors << xpath_get_text(i)
        end
      end
      return @authors
    end

    def summary
      unless @summary
        if xpath_first(@doc, "datafield[@tag='520']") != nil
          @summary = xpath_get_text(xpath_first(@doc, "datafield[@tag='520']/subfield[@code='a']"))
        elsif xpath_first(@doc, "datafield[@tag='500']") != nil
          @summary = xpath_get_text(xpath_first(@doc, "datafield[@tag='500']/subfield[@code='a']"))
        else
          @summary = ''
        end
      end
      return @summary
    end

    def citation
      ''
    end
  end
end
