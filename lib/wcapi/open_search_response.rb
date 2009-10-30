module WCAPI
  class OpenSearchResponse 
    include WCAPI::ResponseParser

    attr_accessor :header, :records, :raw

    def initialize(doc)
      @raw = doc
      @header = {}
      @records = []

      if doc.index('<rss')
        parse_rss(doc)
      elsif doc.index('<feed')
        parse_atom(doc)
      end
    end

    def parse_rss(xml)
      doc = get_parser(xml)
      
      namespaces = {'content' => 'http://purl.org/rss/1.0/modules/content/',
                    'atom' => 'http://www.w3.org/2005/Atom',
		                'opensearch' => 'http://a9.com/-/spec/opensearch/1.1/',
		                'srw' => 'http://www.loc.gov/zing/srw/' }
      
      @header["totalResults"] = xpath_get_text(xpath_first(doc, "//opensearch:totalResults")).to_i
      @header["startIndex"] = xpath_get_text(xpath_first(doc, "//opensearch:startIndex")).to_i
      @header["itemsPerPage"] = xpath_get_text(xpath_first(doc, "//opensearch:itemsPerPage")).to_i

      nodes = xpath_all(doc, "//item", namespaces)
      nodes.each do |item|
        _title = ""
        _author = []
        _link = ""
        _id = ""
        _citation = ""
        _summary = ""

        _title = xpath_get_text(xpath_first(item, "title")) 
        if xpath_first(item, "author/name", namespaces) != nil 
          xpath_all(item, "author/name", namespaces).each do |i|
            _author.push(xpath_get_text(i))
          end
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

        @records << {:title => _title, :author => _author, :link => _link, 
            :id => _id, :citation => _citation, :summary => _summary, :xml => item.to_s}
      end
    end

    def parse_atom(xml)
      namespaces = {'n0' => 'http://www.w3.org/2005/Atom',
                    'opensearch' => 'http://a9.com/-/spec/opensearch/1.1/' }

      doc = get_parser(xml)

      @header["totalResults"] = xpath_get_text(xpath_first(doc, "//opensearch:totalResults")).to_i
      @header["startIndex"] = xpath_get_text(xpath_first(doc, "//opensearch:startIndex")).to_i
      @header["itemsPerPage"] = xpath_get_text(xpath_first(doc, "//opensearch:itemsPerPage")).to_i

      nodes = xpath_all(doc, "//entry]")
      nodes.each do |item|
        _title = ""
        _author = Array.new()
        _link = ""
        _id = ""
        _citation = ""
        _summary = ""
	      _author = []

        _title = xpath_get_text(xpath_first(item, "/title"))
        _tmpauthor = xpath_first(item, "/author']")

        if _tmpauthor != nil
          if xpath_first(item, "/author/name") != nil
            xpath_all(item, "/author/name").each do |i|
              _author.push(xpath_get_text(i))
            end
          end
        end
        
        if xpath_first(item, "/id") != nil
          _link = xpath_get_text(xpath_first(item, "/id"))
        end
        
        if _link != ''
          _id = _link.slice(_link.rindex("/")+1, _link.length-_link.rindex("/"))
        end
        if xpath_first(item, "/content") != nil
          _citation = xpath_get_text(xpath_first(item, "/content"))
        end
        
        if xpath_first(item, "/summary") != nil
          _summary = xpath_get_text(xpath_first(item, "/summary"))
        end
        @records << {:title => _title, :author => _author, :link => _link, :id => _id, 
            :citation => _citation, :summary => _summary, :xml => item.to_s}
      end
    end
  end
end
