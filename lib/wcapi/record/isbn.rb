module WCAPI
  class Record
    class ISBN
      attr_accessor :raw
      
      def initialize(str)
        @raw = str
      end
      
      def to_i
        @id ||= @raw.split.first
      end
      
      def to_s
        @raw
      end
    end
  end
end