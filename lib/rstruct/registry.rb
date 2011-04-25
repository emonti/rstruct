require 'set'

module Rstruct
  class TypeConflictError < StandardError
  end

  class Registry
    def initialize(name, *includes)
      @name = name.to_sym
      @registry = Hash.new()

      @includes = []
      if @name != :default
        @includes << DEFAULT_REGISTRY 
      end
      @includes.concat(includes).uniq!
    end

    def get(typ)
      if t=@registry[typ] 
        return t
      else
        @includes.each do |inc|
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
