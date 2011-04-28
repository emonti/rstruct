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

      @mystruct = Struct.new(*@field_names)
    end

    def groupable?
      @fields.find{|f| not f.groupable?}.nil?
    end
  end
end
