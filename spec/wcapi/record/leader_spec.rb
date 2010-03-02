require File.dirname(__FILE__) + '/../../spec_helper'

describe WCAPI::Record::Leader do
  it "should make the raw value accessible" do
    WCAPI::Record::Leader.new('01427cem  22003731  4500').raw.should == '01427cem  22003731  4500'
  end
end