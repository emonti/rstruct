require 'rstruct/base_types'
require 'rstruct/struct_builder'
require 'rstruct/registry'

module Rstruct
  class StructError < StandardError
  end

  class Structure < ContainerType
    register :struct

    attr_reader :fields, :field_names

    def initialize(name, opts={}, &block)
      builder = opts[:builder] || StructBuilder

      if reg=opts[:register]
        reg=Registry::DEFAULT_REGISTRY if reg==true # true is shorthand for default
        reg.register(self, name.to_sym)
      end

      lkupreg = (opts[:fields_from])

      # pass a nil block to super to ensure we're claiming the caller's
      super(name, opts, &(nil))

      @fields = builder.new((lkupreg || reg), &block).__fields

      raise(StructError, "no fields were defined") if @fields.empty?

      @field_names = @fields.map{|f| f.name }
      @mystruct = Struct.new(*@field_names)
    end

    def container
      @container ||= @mystruct.new
    end

    def groupable?
      @fields.find{|f| not f.groupable? }.nil?
    end

    def _pack
      a = *self.value
      a.pack(self.format)
    end

    def _unpack(raw)
      raw.unpack(self.format)
    end
  end
end
