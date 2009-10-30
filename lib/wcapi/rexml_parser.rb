module WCAPI
  module ResponseParser
    module RexmlParser
      
      def get_parser(xml)
        REXML::Document.new(xml)
      end
      
      # get all matching nodes
      def xpath_all(pdoc, path, namespace = '')
        if namespace!=""
           return REXML::XPath.match(pdoc, path, namespace)
        else
           return REXML::XPath.match(pdoc, path);
        end
        return []
      end

      # get first matching node
      def xpath_first(doc, path, pnamespace = '')
        elements = xpath_all(doc, path, pnamespace)
        (elements != nil) ? elements[0] : nil
      end

      # get text for first matching node
      def xpath(pdoc, path, namespace = '')
        el = xpath_first(pdoc, path, namespace)
        (el != nil) ? el.text : nil
      end

      # get text for element)
      def xpath_get_text(doc)
        if (doc and doc.has_text? == true)
          return doc.text
        else
          return ""
        end
      end

      # get text for element)
      def xpath_get_all_text(doc)
        doc.text
      end

      # get node/element name
      def xpath_get_name(doc)
        doc.name
      end


      # figure out an attribute
      def get_attribute(node, attr_name)
        node.attribute(attr_name)
      end

      private
      # figure out what sort of object we should do xpath on
      def parser_type(x)
        'rexml'
      end
    end
  end
end