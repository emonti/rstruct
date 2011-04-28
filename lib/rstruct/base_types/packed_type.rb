require 'rstruct/base_types/type'

module Rstruct
  module Packable
    private
      # sets up a callback for packing a value to raw data
      # for this type
      def pack(&block)
        @pack_cb = block
      end

      # sets up a callback for unpacking data from a string for
      # this type
      def unpack(&block)
        @unpack_cb = block
      end

    public
      # Called on parsing. While you can override this in subclasses
      # in general, it is probably better to use the 'unpack' method
      # to define a proc to handle unpacking in special cases.
      def unpack_raw(raw, obj=nil)
        if @unpack_cb
          @unpack_cb.call(raw, obj)
        else
          raw.unpack(self.format)
        end
      end

      def pack_value(val, obj=nil)
        if @pack_cb
          @pack_cb.call(val, obj)
        else
          v = *val
          v.pack(self.format)
        end
      end
  end

  class PackedType < Type
    include Packable
    attr_reader :size, :format

    def initialize(name, size, format, opts={}, &block)
      @size = size
      @format = format
      @groupable = true
      super(name, opts, &block)
    end

    def instance(val=nil)
      val
    end
  end
end

