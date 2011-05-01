require 'rstruct/base_types'
require 'rstruct/struct_builder'
require 'rstruct/registry'
require 'rstruct/base_types/array_type'

module Rstruct
  class StructError < StandardError
  end

  class Structure < ContainerType
    attr_reader :fields

    def initialize(name, opts={}, &block)
      lkupreg = (opts[:fields_from]) # allow a seperate reg for member types
      builder = opts[:builder] || StructBuilder
      reg = opts[:register]
      reg=nil if reg==true

      # pass a nil block to super to ensure we're claiming the caller's
      super(name, opts, &(nil))

      @fields = builder.new((lkupreg || reg), &block).__fields
      raise(StructError, "no fields were defined") if @fields.empty?

      # set up our internal struct container class
      # we are taking the field name 'structure' 
      # to reference ourselves
      @mystruct = Struct.new(*self.field_names)
    end

    def instance(values=nil)
      values ||= {}
      vals = []
      self.fields.each do |f|
        v = values[f.name]
        vals << (f.typ.respond_to?(:instance) ? f.typ.instance(v) : v)
      end
      s = @mystruct.new(*vals).extend(ContainerMixins)
      s.rstruct_type = self
      yield(s) if block_given?
      return s
    end

    def offset_of(fld)
      o = 0
      self.fields.each do |f|
        return o if f.name == fld
        o += f.sizeof
      end
      raise(InvalidTypeError, "Invalid type: #{fld}")
    end
  end
end
