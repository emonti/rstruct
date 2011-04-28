require 'rstruct/base_types/type'

module Rstruct
  class PackedType < Type
    attr_reader :size, :format

    def initialize(name, size, format, opts={}, &block)
      @size = size
      @format = format
      @groupable = true
      super(name, opts, &block)
    end

  end
end

