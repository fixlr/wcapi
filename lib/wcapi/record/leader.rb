module WCAPI
  class Record
    class Leader
      def initialize(str)
        @regex = str.match(/([\d]{5})([\dA-Za-z ]{1})([\dA-Za-z ]{1})([\dA-Za-z ]{1})([\dA-Za-z ]{1})([\dA-Za-z ]{1})(2| )(2| )([\d]{5})([\dA-Za-z ]{3})(4500|    )/) || []
      end
      
      def raw
        @regex[0]
      end

      def [](pos)
        @regex[pos]
      end
    end
  end
end