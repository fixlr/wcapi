module WCAPI
  class GetRecordResponse 
    include WCAPI::XPath
    attr_accessor :record, :raw

    def initialize(doc)
      #super doc
      @raw = doc
      parse_marcxml(doc)
    end

   def parse_marcxml(xml)
      _title = ""
      #this is an array
      _author = Array.new()
      _link = ""
      _id = ""
      _citation = ""
      _summary = ""
      _xml = xml
      _rechash = {}
      _x = 0

      begin
         require 'rexml/document'
         doc = REXML::Document.new(xml)
      rescue
 	   #likely some kind of xml error 
      end

      nodes = xpath_all(doc, "/record")
      puts "NODE Count: " + nodes.length.to_s
      nodes.each { |item |
         _title = xpath_get_text(xpath_first(item, "datafield[@tag='245']/subfield[@code='a']")) 
	 puts "TITLE: " + _title
         if xpath_first(item, "datafield[@tag='1*']") != nil 
            xpath_all(item, "datafield[@tag='1*']/sufield[@code='a']").each { |i|
              _author.push(xpath_get_text(i))
           }
         end
         if xpath_first(item, "datafield[@tag='7*']" ) != nil  
            xpath_all(item, "datafield[@tag='7*']/sufield[@code='a']").each { |i|
              _author.push(xpath_get_text(i))
           }
         end

         if xpath_first(item, "controlfield[@tag='001']") != nil 
           _id = xpath_get_text(xpath_first(item, "controlfield[@tag='001']")) 
           _link = 'http://www.worldcat.org/oclc/' + _id.to_s
         end

         if xpath_first(item, "datafield[@tag='520']") != nil
	    _summary = xpath_get_text(xpath_first(item, "datafield[@tag='520']/subfield[@code='a']"))
         else
            if xpath_first(item, "datafield[@tag='500']") != nil
	      _summary = xpath_get_text(xpath_first(item, "datafield[@tag='500']/subfield[@code='a']"))
	    end
	 end

         _rechash = {:title => _title, :author => _author, :link => _link, :id => _id, :citation => _citation, 
		     :summary => _summary, :xml => item.to_s}
      }
      @record = _rechash
   end

  end
end
