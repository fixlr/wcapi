require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::GetRecordResponse do
  describe "with an empty OCLC #" do
    before(:all) do
      @response = WCAPI::GetRecordResponse.new(File.read(File.dirname(__FILE__) + '/../xml/diagnostic_65.xml'))
    end

   it "should assign a GetRecordResponse" do
      @response.should be_an_instance_of(WCAPI::GetRecordResponse)
    end

    it "should assign nil to record" do
      @response.record.should be_nil
    end
  end
  
  describe "with a sample response" do
    before(:all) do
      @response = WCAPI::GetRecordResponse.new(File.read(File.dirname(__FILE__) + '/../xml/get_record_response.xml'))
    end
  
    it "should assign a GetRecordResponse" do
      @response.should be_an_instance_of(WCAPI::GetRecordResponse)
    end
    
    it "should assign a single record" do
      @response.record.should be_an_instance_of(WCAPI::Record)
    end

    # All other WCAPI::Record validations can be found in the record_spec.rb
  end
end