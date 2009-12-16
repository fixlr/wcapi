require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::GetLocationResponse do
  before(:each) do
    @xml = File.read(File.dirname(__FILE__)+'/../xml/get_holding_response.xml')
    @response = WCAPI::GetLocationResponse.new(@xml)
  end

  it "should assign the raw XML" do
    @response.raw.should == @xml
  end
  
  it "should have an array of holdings" do
    @response.locations.should be_an_instance_of(Array)
    @response.locations.each do |holding|
      holding.should be_an_instance_of(WCAPI::Holding)
    end
  end
end