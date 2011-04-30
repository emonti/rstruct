require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'type_behaviors'

describe Rstruct::Structure do
  context "initialization" do
    it "requires a block" do
      lambda { Rstruct::Structure.new(:rstruct_klass_fail_block) }.should raise_error(ArgumentError)
    end

    it "should return a structure" do
      s=Rstruct::Structure.new(:rstruct_klass_return_struct, :register => false){ byte :foo }
      s.should be_a(Rstruct::Structure)
    end

    it "should allow structure fields to be defined" do
      s = Rstruct::Structure.new(:rstruct_klass_struct_test) {
        int32   :someint1
        int32   :someint2
      }
      s.should be_a(Rstruct::Structure)
      s.sizeof.should == 8
      s.fields.should be_an(Array)
      s.field_names.should == [:someint1, :someint2]
      s.field_types.should == [Rstruct::Int32, Rstruct::Int32]
    end

    context 'registration' do

      it "should register a structure by default" do
        s=Rstruct::Structure.new(:rstruct_klass_not_reg_dflt){ byte :foo }
        s.should be_a(Rstruct::Structure)
        Rstruct.default_registry.get(:rstruct_klass_not_reg_dflt).should == s
      end

      it "should allow a struct to explicitely opt out of registration" do
        s=Rstruct::Structure.new(:rstruct_klass_not_reg, :register=>false){ byte :foo}
        s.should be_a(Rstruct::Structure)
        Rstruct.default_registry.get(:rstruct_klass_not_reg).should be_nil
      end

      it "should allow a struct to register itself with the default registry" do
        s=Rstruct::Structure.new(:rstruct_klass_registered, :register=>true){ byte :foo}
        s.should be_a(Rstruct::Structure)
        Rstruct.default_registry.get(:rstruct_klass_registered).should == s
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
        s.field_types.should == [Rstruct::Int32, Rstruct::Int32]

        # confirm the struct is registered
        reg[:rstruct_klass_test_struct1].should == s
      end

      it "should allow structure fields to come from the registry the struct is registered to" do
        # create a registry for this test
        reg = Rstruct::Registry.new(:rstruct_klass_test_reg2)

        # create a test type registered to this registry
        c = Rstruct::Type.new(:reg_test_typ, :register => reg)
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
        Rstruct.default_registry[:rstruct_klass_test_struct].should be_nil

        # confirm declaration went ok
        s.fields.should be_an(Array)
        s.field_names.should == [:someint1, :someint2, :sometype]
        s.field_types.should == [Rstruct::Int32, Rstruct::Int32, c]
      end

      it "should allow fields to come an alternate registry without registration of the struct" do
        # create a registry for this test
        reg = Rstruct::Registry.new(:rstruct_klass_test_reg3)

        # create a test type registered to this registry
        c = Rstruct::Type.new(:reg_test_typ2, :register => reg)
        reg[:reg_test_typ2].should == c

        # create a struct which registers itself to this registry
        # and declares a field of the above type
        s = Rstruct::Structure.new(:rstruct_klass_test_struct2, :fields_from => reg, :register => false) {
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
        s.field_types.should == [Rstruct::Int32, Rstruct::Int32, c]
      end

      it "should allow a struct to register itself to a different registry than some of its fields" do
        # create 2 registries for this test
        reg = Rstruct::Registry.new(:rstuct_klass_test_reg3)
        sreg = Rstruct::Registry.new(:rstuct_klass_test_reg3)

        # create a test type registered to this registry
        c = Rstruct::Type.new(:reg_test_typ2, :register => reg)
        reg[:reg_test_typ2].should == c
        sreg[:reg_test_typ2].should be_nil

        # create a struct which registers to one registry, but looks up fields from another
        # and declares a field of the above type
        s = Rstruct::Structure.new(:rstuct_klass_test_struct3, :fields_from => reg, :register => sreg) {
          int32   :someint1
          int32   :someint2
          reg_test_typ2 :sometype
        }

        # confirm the struct is correctly registered
        sreg[:rstuct_klass_test_struct3].should == s
        reg[:rstuct_klass_test_struct3].should be_nil

        # confirm declaration went ok
        s.fields.should be_an(Array)
        s.field_names.should == [:someint1, :someint2, :sometype]
        s.field_types.should == [Rstruct::Int32, Rstruct::Int32, c]
      end

    end

  end

  context "a simple fixed-length struct" do
    before :each do
      @struct = Rstruct::Structure.new(:simple_fixed_length_struct, :register => false) {
        uint32be  :someint1
        uint32be  :someint2
      }

      @values = { :someint1 => 0xdeadbeef, :someint2 => 0xfacefeeb }

      @instance = @struct.instance
      @populate = lambda { @values.each { |k,v| @instance[k] = v } }

      @pack_format = "NN"
      @rawdata = "\xde\xad\xbe\xef\xfa\xce\xfe\xeb"
    end

    it_should_behave_like "a structure"
    it_should_behave_like "a packable type"
    it_should_behave_like "a groupable type"
  end

  context "a fixed-length mach_header struct" do
    before :each do
      Rstruct.typedef :uint32le, :cpu_type_t unless Rstruct.default_registry[:cpu_type_t]
      Rstruct.typedef :uint32le, :cpu_subtype_t unless Rstruct.default_registry[:cpu_subtype_t]

      @struct = Rstruct.struct(:mach_header, :register => false) {
        uint32le      :magic      # mach magic number identifier
        cpu_type_t    :cputype    # cpu specifier
        cpu_subtype_t :cpusubtype # machine specifier
        uint32le      :filetype   # type of file
        uint32le      :ncmds      # number of load commands
        uint32le      :sizeofcmds # the size of all the load commands
        uint32le      :flags      # flags
      }

      @values = {
        :magic      => 0xfeedface,
        :cputype    => 0x00000007,
        :cpusubtype => 0x00000003,
        :filetype   => 0x00000002,
        :ncmds      => 0x0000000d,
        :sizeofcmds => 0x000005ec,
        :flags      => 0x00000085,
      }

      @instance = @struct.instance
      @populate = lambda { @values.each { |k,v| @instance[k] = v } }

      @pack_format = "VVVVVVV"
      @rawdata = @values.values_at(
        :magic, :cputype, :cpusubtype, :filetype, :ncmds, :sizeofcmds, :flags
      ).pack(@pack_format)

      @rawdata.should == "\316\372\355\376\a\000\000\000\003\000\000\000\002\000\000\000\r\000\000\000\354\005\000\000\205\000\000\000"

    end

    it_should_behave_like "a structure"
    it_should_behave_like "a packable type"
    it_should_behave_like "a groupable type"

    it "should return the correct offset for fields" do
      @struct.offset_of(:magic).should == 0
      @struct.offset_of(:cputype).should == 4
      @struct.offset_of(:cpusubtype).should == 8
      @struct.offset_of(:filetype).should == 12
      @struct.offset_of(:ncmds).should == 16
      @struct.offset_of(:sizeofcmds).should == 20
      @struct.offset_of(:flags).should == 24
    end
  end

  context "a simple fixed-length nested struct" do
    before :each do
      inner_struct = Rstruct::Structure.new(:inner_fix_len_test, :register => true) {
        byte :byte1
        byte :byte2
      } unless Rstruct.default_registry[:inner_fix_len_test]

      @struct = Rstruct::Structure.new(:simple_fixed_length_struct, :register => false) {
        uint32be  :someint1
        uint32be  :someint2
        inner_fix_len_test :inner
      }

      @values = { :someint1 => 0xdeadbeef, :someint2 => 0xfacefeeb }
      inner_values = { :byte1 => 1, :byte2 => 2 }

      @instance = @struct.instance

      @populate = lambda do
        @values.each {|k,v| @instance[k] = v }
        inner_values.each {|k,v| @instance.inner[k] = v}
      end

      @pack_format = "NNcc"
      @rawdata = "\xde\xad\xbe\xef\xfa\xce\xfe\xeb\x01\x02"

      @verify_unpack = lambda do |ret|
        @values.each {|k,v| ret.__send__(k).should == v }
        inner_values.each {|k,v| ret.inner.__send__(k).should == v}
      end
    end

    it_should_behave_like "a structure"
    it_should_behave_like "a packable type"
    it_should_behave_like "a groupable type"
  end

  context "a doubly-nested fixed-length struct" do
    before :each do
      inner_inner_struct = Rstruct.struct(:double_nest_inner, :register => true) {
        char  :dchar1
        char  :dchar2
      } unless Rstruct.default_registry[:double_nest_inner]

      inner_struct = Rstruct.struct(:first_inner, :register => true) {
        byte :byte1
        byte :byte2
        double_nest_inner :double_inner
      } unless Rstruct.default_registry[:first_inner]

      @struct = Rstruct::Structure.new(:double_nest_struct, :register => false) {
        uint32be  :someint1
        uint32be  :someint2
        first_inner :inner
      }

      @values = { :someint1 => 0xdeadbeef, :someint2 => 0xfacefeeb }
      inner_values = { :byte1 => 1, :byte2 => 2 }
      double_inner_values = { :dchar1 => 'A', :dchar2 => 'B' }

      @instance = @struct.instance

      @populate = lambda do
        @values.each {|k,v| @instance[k] = v }
        inner_values.each {|k,v| @instance.inner[k] = v}
        double_inner_values.each {|k,v| @instance.inner.double_inner[k] = v}
      end

      @pack_format = "NNccAA"
      @rawdata = "\xde\xad\xbe\xef\xfa\xce\xfe\xeb\x01\x02\x41\x42"

      @verify_unpack = lambda do |ret|
        @values.each {|k,v| ret.__send__(k).should == v }
        inner_values.each {|k,v| ret.inner.__send__(k).should == v}
        double_inner_values.each {|k,v| ret.inner.double_inner.__send__(k).should == v}
      end
    end

    it_should_behave_like "a structure"
    it_should_behave_like "a packable type"
    it_should_behave_like "a groupable type"
  end

end

