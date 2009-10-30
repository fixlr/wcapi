require 'rubygems'
require 'hpricot'
require 'libxml'

%w(xpath response_parser rexml_parser hpricot_parser libxml_parser client open_search_response get_record_response get_location_response sru_search_response record).each do |file|
  require File.join(File.dirname(__FILE__), 'wcapi', file)
end

WORLDCAT_OPENSEARCH = 'http://www.worldcat.org/webservices/catalog/search/opensearch'
WORLDCAT_SRU = 'http://www.worldcat.org/webservices/catalog/search/sru'
