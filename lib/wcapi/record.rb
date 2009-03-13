module WCAPI

  class Record
    include WCAPI::XPath
    attr_accessor :title, :author, :link, :id, :citation, :summary, :xml

    def initialize(pxml)
       #Setup a document
    end
  end
end
