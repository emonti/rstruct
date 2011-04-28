require 'rstruct/registry'

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

    def is_packable?
      raise(NotImplementedError, 'base class stub called')
    end

  end

  class PackedType < Type
    attr_reader :size, :format

    def initialize(name, size, format, opts={}, &block)
      @name = name.to_sym
      @size = size
      @format = format
      super(name, opts, &block)
    end

    def parse(stream)
      dat=nil
      stream.get{|s| dat = s.read(self.size)}
    end

    def write(stream)
      raise("Value not set") unless self.value?
      dat = *(self.value).pack(self.format)
      stream.put{|s| s.write(dat) }
    end
  end

  class ContainerType < Type
  end

end

