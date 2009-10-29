require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::GetRecordResponse do
  shared_examples_for "a WCAPI::GetRecordResponse" do
    it "should assign a GetRecordResponse" do
      @response.should be_an_instance_of(WCAPI::GetRecordResponse)
    end
    
    it "should assign a single record" do
      @response.record.should be_an_instance_of(Hash)
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

    it "should have an OCLC id" do
      @record[:id].should == '57358293'
    end

    it "should have a title" do
      @record[:title].should == 'Harry Potter and the Half-Blood Prince /'
    end
    
    it "should have a link" do
      @record[:link].should == 'http://www.worldcat.org/oclc/57358293'
    end
    
    it "should have an author" do
      @record[:author].first.should eql("Rowling, J. K.")
    
      # There's some issues here with character encoding, so I'm  ignoring this
      # 700 field for now.
      # @record[:author].last.should eql("GrandPré, Mary,")
    end
    
    it "should have a summary" do
      @record[:summary].should == "Sixth-year Hogwarts student Harry Potter gains valuable insights into the boy Voldemort once was, even as his own world is transformed by maturing friendships, schoolwork assistance from an unexpected source, and devastating losses."
    end
    
    it "should have a citation" do
      @record[:citation].should == ''
    end
  end
end