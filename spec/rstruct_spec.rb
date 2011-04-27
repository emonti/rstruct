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
    c.default_registry.should == Rstruct::Registry::DEFAULT_REGISTRY
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

    it "should allow structure fields to be defined" do
      s = Rstruct.struct(:rspec_struct_test) {
        int32   :someint1
        int32   :someint2
      }
      s.should be_a(Rstruct::Structure)
      s.size.should == 8
      s.format.should == "ll"
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2]
      s.fields.each{|f| f.should be_kind_of(Rstruct::Int32) }
    end

    it "should allow a structure to register itself in a registry and still access default types" do
      # create a registry for this test
      reg = Rstruct::Registry.new(:rstruct_struct_test_reg1)

      # create a struct which registers itself to this registry
      s = Rstruct.struct(:rspec_test_struct1, :register => reg) {
        int32   :someint1
        int32   :someint2
      }

      # confirm declaration went ok
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2]
      s.fields.each{|f| f.should be_kind_of(Rstruct::Int32) }

      # confirm the struct is registered
      reg[:rspec_test_struct1].should == s
    end

    it "should allow structure fields to come from the registry the struct is registered to" do
      # create a registry for this test
      reg = $rstruct_struct_reg_test_reg = Rstruct::Registry.new(:rstruct_struct_test_reg2)

      # create a test type registered to this registry
      c = Class.new(Rstruct::Type)
      c.register :reg_test_typ, $rstruct_struct_reg_test_reg
      reg[:reg_test_typ].should == c

      # create a struct which registers itself to this registry
      # and declares a field of the above type
      s = Rstruct.struct(:rspec_test_struct2, :register => reg) {
        int32   :someint1
        int32   :someint2
        reg_test_typ :sometype
      }

      # confirm the struct is registered
      reg[:rspec_test_struct2].should == s

      # confirm declaration went ok
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2, :sometype]
      s.fields[0,2].each{|f| f.should be_kind_of(Rstruct::Int32) }
      s.fields.last.should be_kind_of(c)

    end

    it "should allow fields to come an alternate registry without registration of the struct" do
      # create a registry for this test
      reg = $rstruct_klass_reg_test_reg2 = Rstruct::Registry.new(:rstruct_klass_test_reg3)

      # create a test type registered to this registry
      c = Class.new(Rstruct::Type)
      c.register :reg_test_typ2, $rstruct_klass_reg_test_reg2
      reg[:reg_test_typ2].should == c

      # create a struct which registers itself to this registry
      # and declares a field of the above type
      s = Rstruct.struct(:rstruct_klass_test_struct2, :fields_from => reg) {
        int32   :someint1
        int32   :someint2
        reg_test_typ2 :sometype
      }

      # confirm the struct is not registered
      reg[:rstruct_klass_test_struct2].should be_nil
      Rstruct.default_registry[:rstruct_klass_test_struct2].should be_nil

      # confirm declaration went ok
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2, :sometype]
      s.fields[0,2].each{|f| f.should be_kind_of(Rstruct::Int32) }
      s.fields.last.should be_kind_of(c)

    end

    it "should not register a structure by default" do
      (s=Rstruct.struct(:rspec_not_reg_dflt){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rspec_not_reg_dflt).should be_nil
    end

    it "should allow a struct to explicitely opt out of registration" do
      (s=Rstruct.struct(:rspec_not_reg, :register=>false){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rspec_not_reg).should be_nil
    end

    it "should allow a struct to register itself with the default registry" do
      (s=Rstruct.struct(:rspec_registered, :register=>true){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rspec_registered).should == s
    end

  end

end
