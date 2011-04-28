require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rstruct do

  it "should be a module" do
    Rstruct.should be_a(Module)
  end

  it "should supply a struct method" do
    Rstruct.should respond_to(:struct)
  end

  it "should supply a helper to access the default registry" do
    Rstruct.should respond_to(:default_registry)
    Rstruct.default_registry.should == Rstruct::Registry::DEFAULT_REGISTRY
  end

  it "should let others import methods with the ClassMethods mixin" do
    c=Class.new(Object){ extend(Rstruct::ClassMethods) }
    c.should respond_to(:struct)
    c.should respond_to(:default_registry)
    c.should respond_to(:typedef)
    c.default_registry.should == Rstruct::Registry::DEFAULT_REGISTRY

    m=Module.new{ extend(Rstruct::ClassMethods) }
    m.should respond_to(:struct)
    m.should respond_to(:default_registry)
    m.should respond_to(:typedef)
    m.default_registry.should == Rstruct::Registry::DEFAULT_REGISTRY
  end

  context 'Typedefs' do
    it "should allow types to be aliased with 'typedef'" do
      Rstruct.typedef(:int32, :int32_copy)
      reg = Rstruct.default_registry
      reg[:int32_copy].should == reg[:int32]
    end

    it "should raise an exception when invalid types are aliased with 'typedef'" do
      lambda{ Rstruct.typedef(:nonexistent_type, :int32_copy) }.should raise_error(Rstruct::InvalidTypeError)
    end
  end

  context "The struct method" do
    it "requires a block" do
      lambda { Rstruct.struct(:rspec_fail_block) }.should raise_error(ArgumentError)
    end

    it "should return a structure" do
      Rstruct.struct(:rspec_return_struct, :register => false){}.should be_a(Rstruct::Structure)
    end

    it "should define structures the same way as by calling Rstruct::Structure.new" do
      s = Rstruct.struct(:rspec_struct_test) {
        int32   :someint1
        int32   :someint2
      }
      s.should be_a(Rstruct::Structure)
      s.size.should == 8
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2]
      s.fields.each{|f| f.should be_kind_of(Rstruct::Int32) }
    end

  end

end
