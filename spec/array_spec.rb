require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'type_behaviors'

describe Rstruct::ArrayType do
  context "a basic character array" do
    before(:each) do
      @struct = Rstruct.struct(:array_test, :register => false) {
        array :test_array, :char, 8
      }
      
      @pack_format = "AAAAAAAA"

      @instance = @struct.instance

      @rawdata = "ABCDEFGH"
      @populate = lambda { @rawdata.bytes.each_with_index{|b,i| @instance.test_array[i] = b.chr} }
      @verify_unpack = lambda {|ret| @rawdata.bytes.each_with_index{|b,i| ret.test_array[i].should == b.chr } }
    end

    it_should_behave_like "a packable type"
    it_should_behave_like "a groupable type"
  end
end

