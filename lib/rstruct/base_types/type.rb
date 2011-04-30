module Rstruct
  class Type
    attr_reader :name, :params

    def initialize(name, params={}, &block)
      @params = params.dup
      @name = name.to_sym

      reg, aliases = params.values_at(:register, :aliases)
      regnames = ((aliases)? ([aliases] << @name) : [@name]).uniq.compact

      reg=nil if reg==true
      register(regnames, reg) unless reg == false

      instance_eval &block if block
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

    def claim_value(vals, predecessors=nil)
      if @claim_cb
        @claim_cb.call(vals, predecessors)
      else
        vals.shift
      end
    end

    def sizeof
      self.size
    end

    private
      # sets up a call back for claiming values out of an unpacked
      # value array
      def claim(&block)
        @claim_cb = block
      end

  end

end

