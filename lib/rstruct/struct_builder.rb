require 'rstruct/registry'
require 'rstruct/field'

module Rstruct

  class StructBuilder
    attr_reader :__fields, :__registry

    def initialize(registry=nil, &block)
      @__fields = []
      @__registry = registry || Registry::DEFAULT_REGISTRY
      instance_eval &block
    end

    def field(name, typ, typ_name, *args, &block)
      @__fields << Field.new(name,typ,typ_name,args,block)
    end

    def method_missing(typ_arg, *args, &block)
      name = args.shift
      unless typ = @__registry.get(typ_arg)
        raise(InvalidTypeError, "invalid field type: #{typ_arg}")
      end

      field(name, typ, typ_arg, *args, &block)
    end
  end

end

