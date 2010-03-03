require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::Holding do
  before(:each) do
    @doc = Hpricot.XML(File.read(File.dirname(__FILE__)+'/../xml/holding.xml'))
    @holding = WCAPI::Holding.new @doc
  end

  it "should be able to create a new Holding" do
    @holding.should be_an_instance_of(WCAPI::Holding)
  end

  it "should remember the raw XML" do
    @holding.doc.should == @doc
  end
  
  it "should know the holding identifier" do
    @holding.code.should == 'CZP'
  end
  
  it "should know the type or source" do
    @holding.type.should == 'http://worldcat.org/registry/institutions/'
  end
  
  it "should know the physical location" do
    @holding.location.should == 'Peninsula Library System'
  end
  
  it "should know the physical address" do
    @holding.address.should == 'San Mateo, CA 94403 United States'
  end
  
  it "should know the electronic address" do
    @holding.url.should == 'http://www.worldcat.org/wcpa/oclc/8114241?page=frame&url=http%3A%2F%2Fcatalog.plsinfo.org%2Fsearch%2Fi0380641135&title=Peninsula+Library+System&linktype=opac&detail=CZP%3APeninsula+Library+System%3APublic&qt=affiliate&ai=wcapi'
  end
  
  it "should know the number of copies of this item that are held" do
    @holding.copies.should == 1
  end
end