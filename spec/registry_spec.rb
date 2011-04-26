require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rstruct::Registry do
  before(:all) do
    @dflt_reg = Rstruct::Registry::DEFAULT_REGISTRY
  end

  it "should have a default registry" do
    @dflt_reg.should be_a(Rstruct::Registry)
  end

  context "default registry" do
    it "should have several basic types already registered" do
      @dflt_reg.get(:byte).should == Rstruct::Byte
      @dflt_reg.get(:char).should == Rstruct::Char
      @dflt_reg.get(:int).should  == Rstruct::Int
      @dflt_reg.get(:short).should == Rstruct::Short
      @dflt_reg.get(:long).should  == Rstruct::Long
      @dflt_reg.get(:uint).should  == Rstruct::Uint
      @dflt_reg.get(:ushort).should == Rstruct::Ushort
      @dflt_reg.get(:ulong).should == Rstruct::Ulong
      @dflt_reg.get(:struct).should == Rstruct::Structure
    end
  end
end
