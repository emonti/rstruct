
shared_examples_for "a basic Rstruct registry" do
  it "should have a name" do
    @registry.name.should == @reg_name
  end

  it "should have basic types already registered or inherited" do
    @registry.get(:byte).should == Rstruct::Byte
    @registry.get(:char).should == Rstruct::Char
    @registry.get(:int).should  == Rstruct::Int
    @registry.get(:short).should == Rstruct::Short
    @registry.get(:long).should  == Rstruct::Long
    @registry.get(:uint).should  == Rstruct::Uint
    @registry.get(:ushort).should == Rstruct::Ushort
    @registry.get(:ulong).should == Rstruct::Ulong
  end

  it "should allow types to be retrieved with 'get' or '[]'" do
    (a=@registry[:byte]).should == Rstruct::Byte
    @registry.get(:byte).should == a
  end

  it "should allow new types to be defined with 'register' or '[]='" do
    typ1 = :"create_#{@registry.name}_1"
    c1 = Class.new(Rstruct::Type)
    @registry[typ1]= c1
    @registry[typ1].should == c1

    typ2 = :"create_#{@registry.name}_2"
    c2 = Class.new(Rstruct::Type)
    @registry.register(c2, typ2)
    @registry[typ2].should == c2
  end

  it "should allow multiple names to be registered at once with 'register'" do
    typ1 = :"create_#{@registry.name}_3"
    typ2 = :"create_#{@registry.name}_4"
    c = Class.new(Rstruct::Type)
    @registry.register(c, typ1, typ2)
    @registry[typ1].should == c
    @registry[typ2].should == c
  end

  it "should raise an exception when a type is defined which already exists" do
    typ = :"create_#{@registry.name}_5"
    c = Class.new(Rstruct::Type)
    @registry[typ] = c
    @registry[typ].should == c
    c2 = Class.new(Rstruct::Type)
    lambda{ @registry[typ] = c2 }.should raise_error(Rstruct::TypeConflictError)
  end

  it "should allow type aliases to be defined with 'typedef'" do
    typ = :"typedef_#{@registry.name}_1"
    @registry.typedef :int, typ
    @registry[:int].should == @registry[typ]
  end

  it "should raise an exception when invalid types are aliased in 'typedef'" do
    typ = :"typedef_#{@registry.name}_2"
    lambda{ @registry.typedef :not_a_type, typ}.should raise_error(Rstruct::InvalidTypeError)
  end

end
