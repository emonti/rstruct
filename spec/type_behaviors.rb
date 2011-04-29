require 'stringio'

shared_examples_for "a packable type" do
  it "should put data to a string correctly without an output" do
  end

  it "should put data to a string object correctly" do
  end

  it "should put data to a StringIO correctly" do
  end

  it "should get values correctly from a string" do
  end

  it "should get values correctly from a StringIO object" do
  end

end

shared_examples_for "a groupable type" do
  it "should be groupable" do
    @struct.should be_groupable
  end

  it "should have the correct format" do
    @struct.format.should == @pack_format
  end
end

shared_examples_for "a structure" do
  it "should return a value instance with a reference back to itself" do
    s = @struct.instance()
    s.rstruct_type.should == @struct
  end

  context "struct instance" do
    it "should expose the same fields as the struct they belong to" do
      s = @struct.instance()
      @struct.field_names.each {|name| s.members.should include(name.to_s) }
    end

    it "should allow struct field values to be set and retrieved with accessors" do
      s = @struct.instance()
      @values.each do |k,v| 
        s.__send__(k).should be_nil
        s.__send__("#{k}=", v).should == v
        s.__send__(k).should == v
      end
    end

    it "should allow field values to be set with arguments to instance creation" do
      vals = @values.values_at(*@struct.field_names)
      s=@struct.instance(*vals)
      s.rstruct_type.should == @struct
      @values.each { |k,v| s.__send__(k).should == v }
    end

    it "should yield itself to a block on instance creation" do
      i=@struct.instance do |s|
        @values.each do |k,v| 
          s.__send__(k).should be_nil
          s.__send__("#{k}=", v).should == v
          s.__send__(k).should == v
        end
      end

      @values.each { |k,v| i.__send__(k).should == v }
    end
  end
end

