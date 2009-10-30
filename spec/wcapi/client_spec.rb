require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::Client do
  before(:all) do
    @client = WCAPI::Client.new(:wckey => 'example')
  end
  
  it "should be an instance of WCAPI::Client" do
    @client.should be_an_instance_of(WCAPI::Client)
  end
  
  it "should be able to get a record" do
    Net::HTTP.expects(:get).returns(File.read(File.dirname(__FILE__)+'/../xml/get_record_response.xml'))
    
    response = @client.GetRecord(:type => "oclc", :id => "15550774")
    response.should be_an_instance_of(WCAPI::GetRecordResponse)
  end

  it "should be able to perform an SRU Search" do
    Net::HTTP.expects(:get).returns(File.read(File.dirname(__FILE__)+'/../xml/sru_search_response.xml'))
    
    response = @client.SRUSearch(:query => 'civil war')
    response.should be_an_instance_of(WCAPI::SruSearchResponse)
  end

  it "should be able to get a record" do
    Net::HTTP.expects(:get).returns(File.read(File.dirname(__FILE__)+'/../xml/open_search_response_rss.xml'))
    
    response = @client.OpenSearch(:q => 'civil war')
    response.should be_an_instance_of(WCAPI::OpenSearchResponse)
  end

end