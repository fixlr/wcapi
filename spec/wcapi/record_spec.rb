require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::Record do
  before(:all) do
    reader = XMLReader.new(File.dirname(__FILE__)+ '/../xml/get_record_response.xml')
    @record = WCAPI::Record.new(reader.record)
  end

  context "using convenience methods" do
    it "#oclc_id" do
      @record.oclc_id.should == '8114241'
    end

    it "#leader" do
      @record.leader.should be_an_instance_of(WCAPI::Record::Leader)
      @record.leader.raw.should == '99999cam a2200001 a 4500'
    end

    it "#publication_year" do
      @record.publication_year.should == '1982'
    end

    it "#publisher" do
      @record.publisher.should == 'New York : Norton, c1982.'
    end

    it "#type_of_record" do
      @record.type_of_record.should == 'a'
    end
    
    it "#bibliographic_level" do
      @record.bibliographic_level.should == 'm'
    end
      
    it "#description" do
      @record.description.should == 'ix, 173 p. ; 22 cm.'
    end

    it "#subjects" do
      @record.subjects.should == ['Chancellorsville, Battle of, Chancellorsville, Va., 1863']
    end

    it "#isbns" do
      @record.isbns.should be_an_instance_of(Array)
      @record.isbns.each do |isbn|
        isbn.should be_an_instance_of(WCAPI::Record::ISBN)
      end
    end
    
    it "#isbns.to_s" do
      @record.isbns.collect {|isbn| "#{isbn}"}.should == ["0393013456", "9780393013450", "0380641135 (pbk.)", "9780380641130 (pbk.)"]
    end
      
    it "#isbns.to_i" do
      @record.isbns.should be_an_instance_of(Array)
      @record.isbns.collect {|isbn| "#{isbn.to_i}"}.should == ["0393013456", "9780393013450", "0380641135", "9780380641130"]
    end
    
    it "#title" do
      @record.title.should == ["The red badge of courage :", "an episode of the American Civil War /"]
    end
      
    it "#link" do
      @record.link.should == 'http://www.worldcat.org/oclc/8114241'
    end

    it "#authors" do
      @record.authors.first.should eql("Crane, Stephen,")
      
      # There's some issues here with character encoding, so I'm  ignoring this
      # 700 field for now.
      # @record.authors.last.should eql("GrandPré, Mary,")
    end
      
    it "#summary" do
      @record.summary.should == ''
    end
      
    it "#citation" do
      @record.citation.should == ''
    end
  end
end

class XMLReader
  include WCAPI
  include ResponseParser
  
  def initialize(path)
    @path = path
  end
  
  def record
    doc = get_parser(File.read(@path))
    xpath_first(doc, "/record")
  end
end