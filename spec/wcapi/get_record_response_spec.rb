require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::GetRecordResponse do
  shared_examples_for "a WCAPI::GetRecordResponse" do
    it "should assign a GetRecordResponse" do
      @response.should be_an_instance_of(WCAPI::GetRecordResponse)
    end
    
    it "should assign a single record" do
      @response.record.should be_an_instance_of(WCAPI::Record)
    end
  end

  describe "with an empty OCLC #" do
    before(:all) do
      @response = WCAPI::GetRecordResponse.new('')
    end
    
    it_should_behave_like "a WCAPI::GetRecordResponse"
  end
  
  describe "with a sample response" do
    before(:all) do
      @response = WCAPI::GetRecordResponse.new(File.read(File.dirname(__FILE__) + '/../xml/get_record_response.xml'))
      @record = @response.record
    end
  
    it_should_behave_like "a WCAPI::GetRecordResponse"
  end
end