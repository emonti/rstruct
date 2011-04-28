require 'stringio'

shared_examples_for "a basic type" do
  it "should put data to a string correctly without an output"

  it "should put data to a string object correctly"

  it "should put data to a StringIO correctly"

  it "should get values correctly from a string"

  it "should get values correctly from a StringIO object"

end

shared_examples_for "a groupable type" do
  it "should be groupable" do
    @struct.should be_groupable
  end

  it "should have the correct format" do
    @struct.format.should == @pack_format
  end
end


