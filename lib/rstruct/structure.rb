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
        reg=Registry::DEFAULT_REGISTRY if reg==true
        reg.register(self, name.to_sym)
      end

      @fields = builder.new(reg, &block).__fields
      size = @fields.inject(0){|s,v| s+=v.size}
      super(name, size, nil)
    end

    def format
      @fields.map{|f| f.format }.join
    end

    def field_names
      @fields.map{|f| f.name}
    end
  end
end
