module WCAPI
  module XPath
    module LibxmlParser
      def get_parser(xml)
        LibXML::XML::Parser.string(xml).parse
      end

      # get all matching nodes
      def xpath_all(pdoc, path, namespace = '')
        begin
          if namespace != ""
             return pdoc.find(path, namespace) if pdoc.find(path, namespace)
          else
             return pdoc.find(path) if pdoc.find(path)
          end
        rescue
          return []
        end
      end

      # get first matching node
      def xpath_first(doc, path, pnamespace = '')
        elements = xpath_all(doc, path, pnamespace)
        (elements != nil) ? elements.first : nil
      end

      # get text for first matching node
      def xpath(pdoc, path, namespace = '')
        el = xpath_first(pdoc, path, namespace)
        return unless el
        return el.content
      end

      # get text for element)
      def xpath_get_text(doc)
        "#{doc}"
        # begin
        #   if doc.text? == false
        #     return doc.content
        #   else
        #     return ""
        #   end
        # rescue
        #   return ""
        # end
      end

      # get text for element)
      def xpath_get_all_text(doc)
        return doc.content
      end

      # get node/element name
      def xpath_get_name(doc)
        if doc.name != 'text'
          return doc.name
        else
          return nil
        end
      end


      # figure out an attribute
      def get_attribute(node, attr_name)
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

      private

      # figure out what sort of object we should do xpath on
      def parser_type(x)
        'libxml'
      end
    end
  end
end