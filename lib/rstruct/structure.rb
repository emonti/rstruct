require 'rstruct/type'
require 'rstruct/struct_builder'
require 'rstruct/registry'

module Rstruct
  class Structure < Type
    register :struct

    attr_reader :fields

    def initialize(name, opts={}, &block)
      builder = opts[:builder] || StructBuilder

      if reg=opts[:register]
        reg=Registry::DEFAULT_REGISTRY if reg==true # true is shorthand for default
        reg.register(self, name.to_sym)
      end

      lkupreg = (opts[:fields_from])

      super(name, opts) {} # need a block here since we're claiming the caller's
      @fields = builder.new((lkupreg || reg), &block).__fields
    end

    def format
      @fields.map{|f| f.format }.join
    end

    def size
      @fields.inject(0){|s,v| s+=v.size}
    end

    def field_names
      @fields.map{|f| f.name}
    end

    def value
      @fields.map{|f| f.value}
    end
  end
end
