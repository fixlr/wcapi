require 'rexml/xpath'

module WCAPI
  module XPath
    
    # Receives raw MARCXML and returns a hash with several MARC data fields
    def parse_marcxml_record(xml)
      _title  = ""
      _author = Array.new()
      _link   = ""
      _id     = ""
      _citation = ""
      _summary  = ""

      _title = xpath_get_text(xpath_first(item, "datafield[@tag='245']/subfield[@code='a']")) 

      if xpath_first(item, "datafield[@tag='100' or @tag='110' or @tag='111']") != nil 
        xpath_all(item, "datafield[@tag='100' or @tag='110' or @tag='111']/subfield[@code='a']").each do |i|
          _author.push(xpath_get_text(i))
        end
      end

      if xpath_first(item, "datafield[@tag='700' or @tag='710' or @tag='711']" ) != nil  
        xpath_all(item, "datafield[@tag='700' or @tag='710' or @tag='711']/subfield[@code='a']").each end |i|
          _author.push(xpath_get_text(i))
        end
      end

      if xpath_first(item, "controlfield[@tag='001']") != nil 
        _id   = xpath_get_text(xpath_first(item, "controlfield[@tag='001']")) 
        _link = 'http://www.worldcat.org/oclc/' + _id.to_s
      end

      if xpath_first(item, "datafield[@tag='520']") != nil
        _summary = xpath_get_text(xpath_first(item, "datafield[@tag='520']/subfield[@code='a']"))
      elsif xpath_first(item, "datafield[@tag='500']") != nil
        _summary = xpath_get_text(xpath_first(item, "datafield[@tag='500']/subfield[@code='a']"))
      end

      return {:title => _title, :author => _author, :link => _link, :id => _id, 
          :citation => _citation, :summary => _summary, :xml => item.to_s }      
    end
    
    # get all matching nodes
    def xpath_all(pdoc, path, namespace = '')
      case parser_type(pdoc)
      when 'libxml'
        if namespace!=""
           return pdoc.find(path, namespace) if pdoc.find(path, namespace)
        else
           return pdoc.find(path) if pdoc.find(path)
        end
      when 'rexml'
        if namespace!=""
           return REXML::XPath.match(pdoc, path, namespace)
        else
           return REXML::XPath.match(pdoc, path);
        end
      end
      return []
    end

    # get first matching node
    def xpath_first(doc, path, pnamespace = '')
      begin
        elements = xpath_all(doc, path, pnamespace)
        if elements != nil
          case parser_type(doc)
            when 'libxml'
                return elements.first
            when 'rexml'
                return elements[0]
            else
                return nil
          end
        else
           return nil
        end
      rescue
         return nil
      end
    end

    # get text for first matching node
    def xpath(pdoc, path, namespace = '')
      el = xpath_first(pdoc, path, namespace)
      return unless el
      case parser_type(pdoc)
      when 'libxml'
        return el.content
      when 'rexml'
        return el.text
      end
      return nil
    end

    # get text for element)
    def xpath_get_text(doc)
      begin
        case parser_type(doc)
        when 'libxml'
          if doc.text? == false
            return doc.content
          else
            return ""
          end
        when 'rexml'
          if doc.has_text? == true
            return doc.text
          else
            return ""
          end
        end
      rescue
        return ""
      end
    end

    # get text for element)
    def xpath_get_all_text(doc)
      begin
        case parser_type(doc)
        when 'libxml'
          return doc.content
        when 'rexml'
          return doc.text
        end
      rescue
        return nil
      end
    end

    # get node/element name
    def xpath_get_name(doc)
      begin
        case parser_type(doc)
        when 'libxml'
          if doc.name != 'text'
            return doc.name
          else
            return nil
          end
        when 'rexml'
          return doc.name
        end
      rescue
        return nil
      end
    end


    # figure out an attribute
    def get_attribute(node, attr_name)
      case node.class.to_s
      when 'REXML::XML::Element'
        return node.attribute(attr_name)
      when 'LibXML::XML::Node'
        #There has been a method shift between 0.5 and 0.7
        if defined?(node.property) == nil
          return node.attributes[attr_name]
        else
          if defined?(node[attr_name])
             return node[attr_name]
          else
             return node.property(attr_name)
          end
        end
      end
      return nil
    end

    private

    # figure out what sort of object we should do xpath on
    def parser_type(x)
      case x.class.to_s
      when 'LibXML::XML::Document'
        return 'libxml'
      when 'LibXML::XML::Node'
        return 'libxml'
      when 'LibXML::XML::Node::Set'
        return 'libxml'
      when 'REXML::Element'
        return 'rexml'
      when 'REXML::Document'
        return 'rexml'
      end
    end
  end
end
