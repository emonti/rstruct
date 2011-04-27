require 'set'

module Rstruct
  class TypeConflictError < StandardError
  end

  class InvalidTypeError < StandardError
  end

  class Registry
    attr_reader :name, :inherits

    def initialize(name, *inherits)
      @name = name.to_sym
      @registry = Hash.new()

      @inherits = []
      if @name != :default
        @inherits << DEFAULT_REGISTRY 
      end
      @inherits.concat(inherits).uniq!
    end

    def typedef(p,t,opts={})
      if (pt = get(p))
        set(t, pt)
      else
        raise(InvalidTypeError, "unknown type: #{p}")
      end
    end

    def get(typ)
      if t=@registry[typ] 
        return t
      else
        @inherits.each do |inc|
          if t=inc.get(typ)
            return t
          end
        end
        return nil
      end
    end

    alias [] get

    def set(n,typ)
      if n.nil?
        raise(TypeConflictError, "can't register nil type")
      elsif v=get(n)
        raise(TypeConflictError, "type already registered: #{n} => #{v.inspect}" ) 
      end
      @registry[n]=typ
    end

    alias []= set

    def register(typ, *names)
      names.each do |n|
        set(n.to_sym,typ)
      end
    end

    DEFAULT_REGISTRY=new(:default)
  end
end
