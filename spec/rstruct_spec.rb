require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rstruct do

  it "should be a module" do
    Rstruct.should be_a(Module)
  end

  it "should supply a struct method" do
    Rstruct.should respond_to(:struct)
  end

  it "should let others have a struct method with the ClassMethods mixin" do
    c=Class.new(Object){ extend(Rstruct::ClassMethods) }
    c.should respond_to(:struct)
  end

  context "The struct method" do
    it "requires a block" do
      lambda { Rstruct.struct(:rspec_fail_block) }.should raise_error(ArgumentError)
    end

    it "should return a structure" do
      Rstruct.struct(:rspec_return_struct, :register => false){}.should be_a(Rstruct::Structure)
    end

    it "should allow structure fields to be defined" do
      s = Rstruct.struct(:rspec_struct_test) {
        someint1 :int32
        someint2 :int32
      }
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2]
      s.size.should == 8
      s.format.should == "ll"
    end

    it "should not register a structure by default" do
      (s=Rstruct.struct(:rspec_not_reg_dflt){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rspec_not_reg_dflt).should be_nil
    end

    it "should allow a struct to register with in the default registry" do
      (s=Rstruct.struct(:rspec_registered, :register=>true){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rspec_registered).should == s
    end

    it "should allow a struct to explicitely opt out of registration" do
      (s=Rstruct.struct(:rspec_not_reg, :register => false){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:not_registered).should be_nil
    end

  end

end
