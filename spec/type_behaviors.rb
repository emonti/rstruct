require 'tempfile'
require 'stringio'

# Applies to types that can be packed.
shared_examples_for "a packable type" do
  context "instances" do
    it "should write data and return a string when no output is specified" do
      @populate.call()
      ret = @instance.write()
      ret.should == @rawdata
    end

    it "should write data to a string object correctly" do
      s = "test"
      @populate.call()
      ret = @instance.write(s)
      ret.should == @rawdata
      s.should == "test" << @rawdata
    end

    it "should write data to a StringIO object correctly" do
      sio = StringIO.new
      @populate.call()
      ret = @instance.write(sio)
      ret.should == @rawdata
      sio.string.should == @rawdata
    end

    it "should write data to a File IO object correctly" do
      begin
        tempf = Tempfile.new('rstruct_test_packing')
        tempf.write("test")
        @populate.call()
        ret = @instance.write(tempf)
        ret.should == @rawdata.size
        tempf.rewind
        tempf.read.should == "test" << @rawdata
      ensure
        tempf.close if tempf
      end
    end



    it "should read data to a populated instance from a string" do
    end

    it "should read data to a populated instance from a StringIO object"

  end
end

# Applies to structs, arrays, or other types that encapsulate
# more than one field.
shared_examples_for "a groupable type" do
  it "should be groupable" do
    @struct.should be_groupable
  end

  it "should have the correct format" do
    @struct.format.should == @pack_format
  end
end

# Applies to structures
shared_examples_for "a structure" do

  it "should return a value instance with a reference back to itself" do
    s = @struct.instance()
    s.rstruct_type.should == @struct
  end

  context "struct instance" do
    it "should expose the same fields as the struct they belong to" do
      @struct.field_names.each {|name| @instance.members.should include(name.to_s) }
    end

    it "should allow struct field values to be set and retrieved with accessors" do
      @values.each do |k,v| 
        @instance.__send__(k).should be_nil
        @instance.__send__("#{k}=", v).should == v
        @instance.__send__(k).should == v
      end
    end

    it "should allow field values to be set with arguments to instance creation" do
      s=@struct.instance(@values)
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

