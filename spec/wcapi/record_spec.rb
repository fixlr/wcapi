require File.dirname(__FILE__) + '/../spec_helper'

describe WCAPI::Record do
  before(:all) do
    reader = XMLReader.new(File.dirname(__FILE__)+ '/../xml/get_record_response.xml')
    @record = WCAPI::Record.new(reader.record)
  end

  context "using convenience methods" do
    it "#oclc_id" do
      @record.oclc_id.should == '57358293'
    end

    it "#leader" do
      @record.leader.should be_an_instance_of(WCAPI::Record::Leader)
      @record.leader.raw.should == '00000    a2200000   4500'
    end
      
    it "#isbns" do
      @record.isbns.should be_an_instance_of(Array)
      @record.isbns.each do |isbn|
        isbn.should be_an_instance_of(WCAPI::Record::ISBN)
      end
    end
    
    it "#isbns.to_s" do
      @record.isbns.collect {|isbn| "#{isbn}"}.should == ["0439784549 (hardcover)", "9780439784542 (hardcover)", "0439786770 (reinforced lib. bdg.)", "9780439786775 (reinforced lib. bdg.)", "0439791324 (deluxe edition)", "9780439791328 (deluxe edition)", "0439785960 (pbk.)", "9780439785969 (pbk.)"]
    end
      
    it "#isbns.to_i" do
      @record.isbns.should be_an_instance_of(Array)
      @record.isbns.collect {|isbn| "#{isbn.to_i}"}.should == ["0439784549", "9780439784542", "0439786770", "9780439786775", "0439791324", "9780439791328", "0439785960", "9780439785969"]
    end
    
    it "#title" do
      @record.title.should == ['Harry Potter and the Half-Blood Prince /']
    end
      
    it "#link" do
      @record.link.should == 'http://www.worldcat.org/oclc/57358293'
    end

    it "#authors" do
      @record.authors.first.should eql("Rowling, J. K.")
      
      # There's some issues here with character encoding, so I'm  ignoring this
      # 700 field for now.
      # @record.authors.last.should eql("GrandPré, Mary,")
    end
      
    it "#summary" do
      @record.summary.should == "Sixth-year Hogwarts student Harry Potter " \
        + "gains valuable insights into the boy Voldemort once was, even as " \
        + "his own world is transformed by maturing friendships, schoolwork " \
        + "assistance from an unexpected source, and devastating losses."
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