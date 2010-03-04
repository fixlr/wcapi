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

    def leader
      @leader ||= WCAPI::Record::Leader.new(xpath_get_text(xpath_first(@doc, "leader")))
    end

    def publication_year
      @pub_year ||= xpath_get_text(xpath_first(@doc, "controlfield[@tag='008']"))[7..10]
    end

    def publisher
      @publisher ||= xpath_all(@doc, "datafield[@tag='260']/subfield").collect {|subfield|
        xpath_get_text(subfield)
      }.join(' ')
    end

    def type_of_record
      "#{leader[3]}"
    end

    def bibliographic_level
      "#{leader[4]}"
    end

    def description
      @description ||= xpath_all(@doc, "datafield[@tag='300']/subfield").collect {|subfield|
        xpath_get_text(subfield)
      }.join(' ')
    end

    def subjects
      @subjects ||= xpath_all(@doc, "datafield[@tag='650']/subfield[@code='a']").collect {|field|
        xpath_get_text(field)
      }
    end

    def isbns
      unless @isbns
        @isbns = []
        xpath_all(@doc, "datafield[@tag='020']/subfield[@code='a']").each do |i|
          @isbns << WCAPI::Record::ISBN.new(xpath_get_text(i))
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
