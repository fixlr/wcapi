require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::OpenSearchResponse do
  shared_examples_for "a WCAPI::OpenSearchResponse" do
    it "should assign a OpenSearchResponse" do
      @response.should be_an_instance_of(WCAPI::OpenSearchResponse)
    end
    
    it "should assign the raw xml" do
      @response.raw.should == @xml
    end
    
    it "should assign an array of records" do
      @response.records.should be_an_instance_of(Array)
      @response.records.each do |record|
        record.should be_an_instance_of(Hash)
      end
    end
  end
  
  shared_examples_for "WCAPI::OpenSearchResponse with sample headers" do
    it "should know the totalResults" do
      @response.header['totalResults'].should == 356704
    end

    it "should know the startIndex" do
      @response.header['startIndex'].should == 1
    end

    it "should know the itemsPerPage" do
      @response.header['itemsPerPage'].should == 10
    end
  end
  
  describe "with an empty query string" do
    before(:all) do
      @xml = ''
      @response = WCAPI::OpenSearchResponse.new(@xml)
    end
    
    it_should_behave_like "a WCAPI::OpenSearchResponse"
  end
  
  describe "with a sample RSS response" do
    before(:all) do
      @xml = File.read(File.dirname(__FILE__)+'/../xml/open_search_response_rss.xml')
      @response = WCAPI::OpenSearchResponse.new(@xml)
      @records = @response.records
    end
    
    it_should_behave_like "a WCAPI::OpenSearchResponse"
    it_should_behave_like "WCAPI::OpenSearchResponse with sample headers"
  end
  
  describe "with a sample ATOM response" do
    before(:all) do
      @xml = File.read(File.dirname(__FILE__)+'/../xml/open_search_response_atom.xml')
      @response = WCAPI::OpenSearchResponse.new(@xml)
      @records = @response.records
    end
    
    it_should_behave_like "a WCAPI::OpenSearchResponse"
    it_should_behave_like "WCAPI::OpenSearchResponse with sample headers"
  end
end