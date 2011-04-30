require 'rstruct/base_types/type'

module Rstruct
  class PackError < StandardError
  end

  class ReadError < StandardError
  end

  module Packable
    private
      # sets up a callback for packing a value to raw data
      # for this type
      def on_pack(&block)
        @pack_cb = block
      end

      # sets up a callback for unpacking data from a string for
      # this type
      def on_unpack(&block)
        @unpack_cb = block
      end

    public
      # Called when parsing. While you can override this in subclasses,
      # in general it is probably better to use the 'on_unpack' method
      # to define a proc to handle unpacking for special cases.
      def unpack_raw(raw, predecessors=nil)
        if raw.respond_to?(:read)
          raw = raw.read(self.sizeof())
        end
        if raw.size < self.sizeof()
          raise(ReadError, "Expected #{self.sizeof} bytes, but only got #{raw.size} bytes")
        end

        vals = 
          if @unpack_cb
            @unpack_cb.call(raw, predecessors)
          else
            raw.unpack(self.format)
          end
        return(self.claim_value(vals, predecessors))
      end

      # Called when composing raw data. While you can override this in
      # subclasses, in general it is probably better to use the 'on_pack'
      # method to define a proc to handle packing for special cases.
      def pack_value(val, obj=nil)
        begin
          if @pack_cb
            @pack_cb.call(val, obj)
          else
            (val.is_a?(Array)? val : [val]).pack(self.format)
          end
        rescue => e
          raise(PackError, "Error packing #{val.inspect} as type #{self.name.inspect} -- #{e.class} -> #{e}")
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

