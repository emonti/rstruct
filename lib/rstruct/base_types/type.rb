module Rstruct
  class Type
    module ClassMethods
      def instance(*args)
        new(*args)
      end

      def to_sym
        self.name.to_s.split('::').last.gsub(/(^|[a-z])([A-Z])/) do 
          ($1.empty?)? $2 : "#{$1}_#{$2}"
        end.downcase.to_sym
      end

      def register(names=nil, reg=nil)
        names ||= to_sym
        reg ||= Registry::DEFAULT_REGISTRY
        reg.register(self, *names)
      end

    end

    def self.inherited(base)
      base.extend(ClassMethods)
    end

    attr_reader :name
    attr_accessor :value

    def initialize(name, opts={}, &block)
      @opts = opts.dup
      @name = name
      yield self if block_given?
    end

    def parse(stream)
      raise(NotImplementedError, 'base class stub called')
    end

    def write(stream)
      raise(NotImplementedError, 'base class stub called')
    end

    def groupable?
      false
    end

    def instance
      v=self.value
      i=self.clone
      self.value=v
      return i
    end

    def claim(vals, keep=nil)
      v = vals.shift
      self.value = v if keep
      v
    end

    def pack(out=nil)
      raw = _pack()
      case out
      when String
        out << raw
      when out.respond_to?(:write)
        out.write(raw)
      when nil
        raw
      else
        raise(TypeError, "invalid output type: #{out.class}")
      end
    end

    def unpack(input, opts={})
      keep = opts[:keep]
      keep = true if keep.nil?

      dat = 
        if String===input
          input
        elsif input.respond_to?(:read)
          input.read(self.size)
        else
          raise(TypeError, "invalid input type: #{input.class}")
        end

      vals=_unpack(dat)
      self.claim(vals, keep)
    end

    def value=(val)
      @value = val
    end
    private :value=
  end

end

