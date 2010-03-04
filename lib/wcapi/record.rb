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
      @isbns ||= xpath_all(@doc, "datafield[@tag='020']/subfield[@code='a']").collect do |i|
        WCAPI::Record::ISBN.new(xpath_get_text(i))
      end
    end

    def link
      "http://www.worldcat.org/oclc/#{self.oclc_id}"
    end

    def title
      @title ||= ['a', 'b'].collect do |code|
        xpath_get_text(xpath_first(@doc, "datafield[@tag='245']/subfield[@code='#{code}']"))
      end
    end
    
    def authors
      @authors ||= ['100', '110', '111', '700', '710', '711'].collect do |tag|
        xpath_get_text(xpath_first(@doc, "datafield[@tag='#{tag}']/subfield[@code='a']"))
      end
    end

    def summary
      unless @summary
        @summary ||= ''  # default empty string
      
        # Check for both 500 and 520, but give preference to the 520
        ['500', '520'].each do |tag|
          if xpath_first(@doc, "datafield[@tag='#{tag}']") != nil
            @summary = xpath_get_text(xpath_first(@doc, "datafield[@tag='#{tag}']/subfield[@code='a']"))
          end
        end
      end
      return @summary
    end

    def citation
      ''
    end
  end
end
