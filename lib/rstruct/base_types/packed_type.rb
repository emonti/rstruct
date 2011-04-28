require 'rstruct/base_types/type'

module Rstruct
  class PackedType < Type
    attr_reader :size, :format, :value

    def initialize(name, size, format, opts={}, &block)
      @name = name.to_sym
      @size = size
      @format = format
      super(name, opts, &block)
    end

    public :value=

    def parse(stream)
      dat=nil
      stream.get{|s| dat = s.read(self.size)}
    end

    def write(stream)
      raise("Value not set") unless self.value
      dat = *(self.value).pack(self.format)
      stream.put{|s| s.write(dat) }
    end

    def groupable?
      true
    end

    def _pack
      a = *self.value
      a.pack(self.format)
    end

    def _unpack(raw)
      raw.unpack(self.format)
    end

  end
end

