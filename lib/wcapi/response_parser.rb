module WCAPI
  module ResponseParser
    def self.included(mod)
      begin
        require 'hpricot'
        mod.send(:include, WCAPI::ResponseParser::HpricotParser)
      rescue
        require 'rexml/xpath'
        mod.send(:include, WCAPI::ResponseParser::RexmlParser)
      end
    end
  end
end