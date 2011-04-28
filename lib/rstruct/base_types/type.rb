module Rstruct
  class Type
    attr_reader :name

    def initialize(name, opts={}, &block)
      @opts = opts.dup
      @name = name.to_sym

      reg, aliases = opts.values_at(:register, :aliases)
      regnames = ((aliases)? ([aliases] << @name) : [@name]).uniq.compact

      reg=nil if reg==true
      register(regnames, reg) unless reg == false

      yield self if block_given?
    end

    def register(names=nil, reg=nil)
      names ||= to_sym
      reg ||= Registry::DEFAULT_REGISTRY
      reg.register(self, *names)
    end

    def groupable?
      @groupable or false
    end

    def container?
      @container or false
    end

  end

end

