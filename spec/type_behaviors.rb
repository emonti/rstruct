shared_examples_for "a parseable type" do
  it "should read and parse a raw string correctly"

  it "should read and parse raw data from StringIO stream correctly"

  it "should read and parse raw data from file io stream correctly"

  it "should read and parse raw data from a network stream correctly"
end

shared_examples_for "a composeable type" do
  it "should compose a string correctly"

  it "should be writeable to a StringIO stream correctly"

  it "should be writeable to a file io stream correctly"

  it "should be writeable to a network stream correctly"
end
