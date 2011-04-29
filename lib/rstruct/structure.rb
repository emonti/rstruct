require 'rstruct/base_types'
require 'rstruct/struct_builder'
require 'rstruct/registry'

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

    def instance(*vals)
      s = @mystruct.new(*vals).extend(ContainerMixins)
      s.container_type = self
      yield(s) if block_given?
      return s
    end

    def claim_value(vals, obj=nil)
      if @claim_cb
        @claim_cb.call(vals, obj)
      else
        # create our struct container
        s = @mystruct.new(self)

        # iterate through the fields assigning values in the
        # container and pass it along with values to each
        # field's claim_value method.
        self.fields.do {|f| s[f.name] = f.typ.claim_value(vals,s) }

        return s
      end
    end
  end
end
