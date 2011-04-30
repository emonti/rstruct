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

    def respond_to?(arg)
      super(arg) || @typ.respond_to?(arg)
    end

    def method_missing(name, *args, &block)
      @typ.__send__(name, *args, &block)
    end
  end
end

