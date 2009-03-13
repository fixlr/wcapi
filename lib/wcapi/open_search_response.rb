module WCAPI
  class OpenSearchResponse 
    include WCAPI::XPath
    attr_accessor :header, :records, :raw

    def initialize(doc)
      #super doc
      @raw = doc
      if doc.index('rss')
        parse_rss(doc)
      else
	parse_atom(doc)
      end
    end

   def parse_rss(xml)
      _title = ""
      #this is an array
      _author = Array.new()
      _link = ""
      _id = ""
      _citation = ""
      _summary = ""
      _xml = xml
      _record = Array.new()
      _x = 0

      begin
        require 'xml/libxml'
        _parser = LibXML::XML::Parser.new()
        _parser.string = xml
        doc = LibXML::XML::Document.new()
        doc = _parser.parse
      rescue
 	begin
	   require 'rexml/document'
           doc = REXML::Document.new(xml)
        rescue
   	   #likely some kind of xml error 
        end
      end

      namespaces = {'content' => 'http://purl.org/rss/1.0/modules/content/',
                    'atom' => 'http://www.w3.org/2005/Atom',
		    'opensearch' => 'http://a9.com/-/spec/opensearch/1.1/',
		    'srw' => 'http://www.loc.gov/zing/srw/'
                   }

      
      @header = {}
      @header["totalResults"] = xpath_get_text(xpath_first(doc, "//opensearch:totalResults"))
      @header["startIndex"] = xpath_get_text(xpath_first(doc, "//opensearch:startIndex"))
      @header["itemsPerPage"] = xpath_get_text(xpath_first(doc, "//opensearch:itemsPerPage"))

      nodes = xpath_all(doc, "//item", namespaces)
      nodes.each { |item |
         _title = xpath_get_text(xpath_first(item, "title")) 
         if xpath_first(item, "author/name", namespaces) != nil 
            xpath_all(item, "author/name", namespaces).each { |i|
              _author.push(xpath_get_text(i))
           }
         end
         if xpath_first(item, "link", namespaces) != nil 
           _link = xpath_get_text(xpath_first(item, "link", namespaces)) 
         end

         if _link != ''
           _id = _link.slice(_link.rindex("/")+1, _link.length-_link.rindex("/"))
         end 
         if xpath_first(item, "content:encoded", namespaces) != nil 
            _citation = xpath_get_text(xpath_first(item, "content:encoded", namespaces))
         end

         if xpath_first(item, "description", namespaces) != nil
	    _summary = xpath_get_text(xpath_first(item, "description", namespaces))
	 end
         _rechash = {:title => _title, :author => _author, :link => _link, :id => _id, :citation => _citation, 
		     :summary => _summary, :xml => item.to_s}
         _record.push(_rechash)
      }
      @records = _record
   end

   def parse_atom(xml)
      _title = ""
      #this is an array
      _author = Array.new()
      _link = ""
      _id = ""
      _citation = ""
      _summary = ""
      _xml = xml
      _record = Array.new()
      _x = 0

      begin
        require 'xml/libxml'
        _parser = LibXML::XML::Parser.new()
        _parser.string = xml
        doc = LibXML::XML::Document.new()
        doc = _parser.parse
      rescue
        begin
           require 'rexml/document'
           doc = REXML::Document.new(xml)
        rescue
           #likely some kind of xml error
        end
      end

      namespaces = {'n0' => 'http://www.w3.org/2005/Atom',
                    'opensearch' => 'http://a9.com/-/spec/opensearch/1.1/'
                   }


      @header = {}
      @header["totalResults"] = xpath_get_text(xpath_first(doc, "//opensearch:totalResults"))
      @header["startIndex"] = xpath_get_text(xpath_first(doc, "//opensearch:startIndex"))
      @header["itemsPerPage"] = xpath_get_text(xpath_first(doc, "//opensearch:itemsPerPage"))

      nodes = xpath_all(doc, "//*[local-name()='entry']")
      nodes.each { |item |
	 _author = []
         _title = xpath_get_text(xpath_first(item, "*[local-name() = 'title']"))
 	 _tmpauthor = xpath_first(item, "*[local-name() = 'author']")

         if _tmpauthor != nil
            if xpath_first(item, "*[local-name() = 'author']/*[local-name() = 'name']") != nil
              xpath_all(item, "*[local-name() = 'author']/*[local-name() = 'name']").each { |i|
                _author.push(xpath_get_text(i))
              }
            end
 	 end

         if xpath_first(item, "*[local-name() = 'id']") != nil
           _link = xpath_get_text(xpath_first(item, "*[local-name() = 'id']"))
         end

         if _link != ''
           _id = _link.slice(_link.rindex("/")+1, _link.length-_link.rindex("/"))
         end
         if xpath_first(item, "*[local-name() = 'content']") != nil
            _citation = xpath_get_text(xpath_first(item, "*[local-name() = 'content']"))
         end

         if xpath_first(item, "*[local-name() = 'summary']") != nil
            _summary = xpath_get_text(xpath_first(item, "*[local-name() = 'summary']"))
         end
         _rechash = {:title => _title, :author => _author, :link => _link, :id => _id, :citation => _citation,
                     :summary => _summary, :xml => item.to_s}
         _record.push(_rechash)
      }
      @records = _record
   end

  end
end
