require 'rstruct/registry'

module Rstruct

  class StructBuilder
    attr_reader :__fields, :__registry

    def initialize(registry=nil, &block)
      @__fields = []
      @__registry = registry || Registry::DEFAULT_REGISTRY
      instance_eval &block
    end

    def method_missing(typ_arg, *args, &block)
      name = args.shift
      unless typ = @__registry.get(typ_arg)
        raise TypeNotFoundError, "invalid field type #{typ_arg}"
      end

      # We accept what look like object references to
      # types. This allows us to handle pointers and arrays
      # in a declarative manner similar to C structs.
      if name.nil? and args.empty?
        return typ
      else
        __field(typ, name, *args, &block)
      end
    end

    def __field(typ, name, *args, &block)
      @__fields << typ.instance(name, *args, &block)
    end
  end

end

