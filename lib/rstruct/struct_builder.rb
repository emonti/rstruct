require 'rstruct/registry'

module Rstruct
  class StructError < StandardError
  end

  class StructBuilder
    attr_reader :__fields, :__registry

    def initialize(registry=nil, &block)
      @__fields = []
      @__registry = registry || Registry::DEFAULT_REGISTRY
      instance_eval &block
    end

    def method_missing(name, typ_arg, *args, &block)
      if typ = @__registry.get(typ_arg)
        __field(typ, name, *args, &block)
      else
        raise StructError, "invalid field type #{typ_arg}"
      end
    end

    def __field(typ, name, *args, &block)
      @__fields << typ.instance(name, *args, &block)
    end

  end
end

