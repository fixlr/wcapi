%w(response_parser rexml_parser hpricot_parser client open_search_response get_record_response get_location_response sru_search_response record record/isbn record/leader holding).each do |file|
  require File.join(File.dirname(__FILE__), 'wcapi', file)
end

WORLDCAT_OPENSEARCH = 'http://www.worldcat.org/webservices/catalog/search/opensearch'
WORLDCAT_SRU = 'http://www.worldcat.org/webservices/catalog/search/sru'
WORLDCAT_GETRECORD = "http://www.worldcat.org/webservices/catalog/content/"
WORLDCAT_GETRECORD_ISBN = "#{WORLDCAT_GETRECORD}/isbn/"
WORLDCAT_GETLOCATION = "http://www.worldcat.org/webservices/catalog/content/libraries/"
WORLDCAT_GETLOCATION_ISBN = "#{WORLDCAT_GETLOCATION}/isbn/"
WORLDCAT_GETCITATION = "http://www.worldcat.org/webservices/catalog/content/citations/"
WORLDCAT_GETCITATION_ISBN = "#{WORLDCAT_GETCITATION}/isbn/"