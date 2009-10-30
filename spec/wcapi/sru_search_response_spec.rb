require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::SruSearchResponse do
  shared_examples_for "a WCAPI::SruSearchResponse" do
    it "should assign a SruSearchResponse" do
      @response.should be_an_instance_of(WCAPI::SruSearchResponse)
    end
    
    it "should assign the raw xml" do
      @response.raw.should == @xml
    end
    
    it "should assign an array of records" do
      @response.records.should be_an_instance_of(Array)
      @response.records.each do |record|
        record.should be_an_instance_of(WCAPI::Record)
      end
    end
  end
  
  describe "with an empty query string" do
    before(:all) do
      @xml = ''
      @response = WCAPI::SruSearchResponse.new(@xml)
    end
    
    it_should_behave_like "a WCAPI::SruSearchResponse"
  end
  
  describe "with a sample MARCXML response" do
    before(:all) do
      @xml = File.read(File.dirname(__FILE__)+'/../xml/sru_search_response.xml')
      @response = WCAPI::SruSearchResponse.new(@xml)
      @records = @response.records
    end
    
    it_should_behave_like "a WCAPI::SruSearchResponse"
    
    it "should know the numberOfRecords" do
      @response.header['numberOfRecords'].should == 253773
    end
  
    it "should know the recordSchema" do
      @response.header['recordSchema'].should == 'info:srw/schema/1/marcxml-v1.1'
    end

    it "should know the nextRecordPosition" do
      @response.header['nextRecordPosition'].should == 11
    end

    it "should know the maximumRecords" do
      @response.header['maximumRecords'].should == 10
    end

    it "should have a records array the size of maximumRecords" do
      @response.header['maximumRecords'].should == @records.size
    end

    it "should know the startRecord" do
      @response.header['startRecord'].should == 1
    end
  end
end