require 'rstruct/registry'
require 'rstruct/field'
require 'rstruct/base_types'

module Rstruct
  class ArrayContainer < Array
    include ContainerMixins
  end

  class ArrayType < ContainerType
    attr_reader :count

    def initialize(name, typ, count, opts={}, &block)
      lkupreg = (opts[:fields_from] || opts[:register] || Rstruct.default_registry)
      super(name, opts, &block)
      @count = count
      unless @rtype = lkupreg[typ]
        raise(InvalidTypeError, "invalid array type #{typ.inspect}")
      end
    end

    def typ
      self
    end

    def fields
      @fields ||= Array.new(self.count){|i| Field.new(i, @rtype, nil, nil) }.freeze
    end

    def instance(*values)
      vals = values.flatten
      ary = ArrayContainer.new(self.count){|f| vals.shift }
      ary.rstruct_type = self
      return ary
    end

    def offset_of(idx)
      rtype.sizeof * idx
    end
  end
end
