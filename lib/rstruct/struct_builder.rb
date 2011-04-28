require 'rstruct/registry'

module Rstruct

  class Field
    attr_reader :name, :typ_name, :typ, :args, :block

    def initialize(name, typ, typ_name, args, block)
      @name=name
      @typ=typ
      @typ_name = typ_name || typ
      @args=args
      @block=block
    end

    def method_missing(name, *args, &block)
      @typ.__send__(name, *args, &block)
    end
  end

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

