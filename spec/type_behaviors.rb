require 'tempfile'
require 'stringio'
require 'pry'

# Applies to types that can be packed.
shared_examples_for "a packable type" do
  context "instances" do
    it "should write raw data and return a string when no output is specified" do
      @populate.call()
      ret = @instance.write()
      ret.bytes.to_a.should == @rawdata.bytes.to_a
    end

    it "should write raw data to a string object correctly" do
      s = "test"
      @populate.call()
      ret = @instance.write(s)
      ret.bytes.to_a.should == @rawdata.bytes.to_a
      s.bytes.to_a.should == "test#{@rawdata}".bytes.to_a
    end

    it "should write raw data to a StringIO object correctly" do
      sio = StringIO.new
      @populate.call()
      ret = @instance.write(sio)
      ret.bytes.to_a.should == @rawdata.bytes.to_a
      sio.string.bytes.to_a.should == @rawdata.bytes.to_a
    end

    it "should write raw data to a File IO object correctly" do
      begin
        tempf = Tempfile.new('rstruct_test_packing')
        tempf.write("test")
        @populate.call()
        ret = @instance.write(tempf)
        ret.should == @rawdata.bytesize
        tempf.rewind
        tempf.read.bytes.to_a.should == "test#{@rawdata}".bytes.to_a
      ensure
        tempf.close if tempf
      end
    end
  end

  context "parsing" do
    it "should read data from a String object and return a populated container instance" do
      datcp = @rawdata.dup
      ret = @struct.read(@rawdata)
      if @verify_unpack
        @verify_unpack.call(ret)
      else
        @values.each {|k,v| ret.__send__(k).should == v }
      end
      @rawdata.should == datcp # ensure the original string was not modified
    end

    it "should read data from a StringIO object and return a populated container instance" do
      sio = StringIO.new()
      sio.write(@rawdata)
      testend = "#{rand(9999)}testend"
      sio.write(testend)
      sio.rewind()
      ret = @struct.read(sio)
      if @verify_unpack
        @verify_unpack.call(ret)
      else
        @values.each {|k,v| ret.__send__(k).should == v }
      end
      sio.read().should == testend
    end

    it "should read data from a File object and return a populated container instance" do
      begin
        fio = Tempfile.new('rstruct_test_unpacking')
        fio.write(@rawdata)
        testend = "#{rand(9999)}testend"
        fio.write(testend)
        fio.rewind()
        ret = @struct.read(fio)
        if @verify_unpack
          @verify_unpack.call(ret)
        else
          @values.each {|k,v| ret.__send__(k).should == v }
        end
        fio.read().bytes.to_a.should == testend.bytes.to_a
      ensure
        fio.close if fio
      end
    end

    it "should parse to an instance which can be rewritten correctly" do
      datcp = @rawdata.dup
      ret = @struct.read(@rawdata)
      if @verify_unpack
        @verify_unpack.call(ret)
      else
        @values.each {|k,v| ret.__send__(k).should == v }
      end
      repacked = ret.write()
      repacked.bytes.to_a.should == @rawdata.bytes.to_a
    end

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


