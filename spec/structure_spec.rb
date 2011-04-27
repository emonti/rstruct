require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'type_behaviors'

describe Rstruct::Structure do
  context "initialization" do
    it "requires a block" do
      lambda { Rstruct::Structure.new(:rstruct_klass_fail_block) }.should raise_error(ArgumentError)
    end

    it "should return a structure" do
      Rstruct::Structure.new(:rstruct_klass_return_struct, :register => false){}.should be_a(Rstruct::Structure)
    end

    it "should allow structure fields to be defined" do
      s = Rstruct::Structure.new(:rstruct_klass_struct_test) {
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
      reg = Rstruct::Registry.new(:rstruct_klass_test_reg1)

      # create a struct which registers itself to this registry
      s = Rstruct::Structure.new(:rstruct_klass_test_struct1, :register => reg) {
        int32   :someint1
        int32   :someint2
      }

      # confirm declaration went ok
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2]
      s.fields.each{|f| f.should be_kind_of(Rstruct::Int32) }

      # confirm the struct is registered
      reg[:rstruct_klass_test_struct1].should == s
    end

    it "should allow structure fields to come from the registry the struct is registered to" do
      # create a registry for this test
      reg = $rstruct_klass_reg_test_reg = Rstruct::Registry.new(:rstruct_klass_test_reg2)

      # create a test type registered to this registry
      c = Class.new(Rstruct::Type)
      c.register :reg_test_typ, $rstruct_klass_reg_test_reg
      reg[:reg_test_typ].should == c

      # create a struct which registers itself to this registry
      # and declares a field of the above type
      s = Rstruct::Structure.new(:rstruct_klass_test_struct2, :register => reg) {
        int32   :someint1
        int32   :someint2
        reg_test_typ :sometype
      }

      # confirm the struct is registered
      reg[:rstruct_klass_test_struct2].should == s

      # confirm declaration went ok
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2, :sometype]
      s.fields[0,2].each{|f| f.should be_kind_of(Rstruct::Int32) }
      s.fields.last.should be_kind_of(c)

    end

    it "should not register a structure by default" do
      (s=Rstruct::Structure.new(:rstruct_klass_not_reg_dflt){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rstruct_klass_not_reg_dflt).should be_nil
    end

    it "should allow a struct to explicitely opt out of registration" do
      (s=Rstruct::Structure.new(:rstruct_klass_not_reg, :register=>false){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rstruct_klass_not_reg).should be_nil
    end

    it "should allow a struct to register itself with the default registry" do
      (s=Rstruct::Structure.new(:rstruct_klass_registered, :register=>true){}).should be_a(Rstruct::Structure)
      Rstruct.default_registry.get(:rstruct_klass_registered).should == s
    end

  end

  context "A simple fixed-length struct" do
    before :all do
      @struct = Rstruct::Structure.new(:simple_fixed_length_struct) {
        int32   :someint1
        int32   :someint2
      }
    end

    it_should_behave_like "a parseable type"
    it_should_behave_like "a composeable type"
  end

end
