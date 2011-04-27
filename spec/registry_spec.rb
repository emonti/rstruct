require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'registry_behaviors'

describe Rstruct::Registry do
  before(:all) do
    @dflt_reg = Rstruct::Registry::DEFAULT_REGISTRY
  end

  it "should have a default registry" do
    @dflt_reg.should be_a(Rstruct::Registry)
  end

  context "default registry" do
    before(:all) do
      @registry = @dflt_reg
      @reg_name = :default
    end

    it_should_behave_like "a basic Rstruct registry"

  end

  context "creating a new registry" do
    before(:all) do
      @reg_name = :rspec_test_registry
      @preg = Rstruct::Registry.new(:parent_reg)
      @registry = Rstruct::Registry.new(@reg_name)
    end

    it "should inherit types from the default registry" do
      @registry[:byte].should == Rstruct::Byte
      @registry[:int].should == Rstruct::Int
      @registry.inherits.should == [Rstruct.default_registry]
    end

    it "should inherit types from arbitrary registries" do
      begin
        @registry.inherits.unshift(@preg)
        c=Class.new(Rstruct::Type)
        @preg.register(c, :some_parent_reg_type)
        @preg[:some_parent_reg_type].should == c
        @registry[:some_parent_reg_type].should == c
        Rstruct.default_registry[c].should be_nil
      ensure
        @registry.inherits.delete(@preg)
      end
        
    end

    it "should register types only to its own registry" do
      typ = :"test_parent_reg_#{@registry.name}_1"
      obj=Class.new(Rstruct::Type)

      @registry.register(obj,typ)
      @registry[typ].should == obj
      Rstruct.default_registry[typ].should be_nil
    end

    it_should_behave_like "a basic Rstruct registry"

  end
end
