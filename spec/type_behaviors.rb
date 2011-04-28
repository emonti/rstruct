require 'stringio'

shared_examples_for "a packable type" do
  it "should pack to a string correctly without an output" do
    @populate.call()
    @struct.pack.should == @rawdat
  end

  it "should unpack correctly from a string" do
    ret=@struct.unpack(@rawdat)
#    @values.each { |k,v| @struct[k].should == v }
  end

  it "should unpack correctly from a StringIO object" do
    s=StringIO.new(@rawdat)
    ret=@struct.unpack(s)
#    @values.each { |k,v| @struct[k].should == v }
  end


end

shared_examples_for "a groupable type" do
  it "should be groupable" do
    @struct.should be_groupable
  end

  it "should have the correct format" do
    @struct.format.should == @pack_format
  end

  it_should_behave_like "a packable type"
end


