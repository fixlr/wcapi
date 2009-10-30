module WCAPI
  module ResponseParser
    module HpricotParser
      def get_parser(xml)
        Hpricot.XML(xml)
      end
      
      # get all matching nodes
      def xpath_all(pdoc, path, namespace = '')
        pdoc.search(path) || []
      end

      # get first matching node
      def xpath_first(doc, path, pnamespace = '')
        elements = xpath_all(doc, path, pnamespace)
        (elements != nil) ? elements.first : nil
      end

      # get text for first matching node
      def xpath(pdoc, path, namespace = '')
        pdoc.at(path).innerHTML
      end

      # get text for element)
      def xpath_get_text(doc)
        doc.innerHTML unless doc.nil?
      end

      # get text for element)
      def xpath_get_all_text(doc)
        doc.innerHTML unless doc.nil?
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
        'hpricot'
      end
    end
  end
end