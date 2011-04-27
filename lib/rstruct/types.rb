require 'rstruct/type'

module Rstruct

  class Byte < PackedType
    register [:byte, :BYTE]

    def initialize(name, opts={})
      super(name, 1, "C")
    end
  end

  class Char < PackedType
    register [:char, :char_t]

    def initialize(name, opts={})
      super(name, 1, "A")
    end
  end

  class Int < PackedType
    register [:int, :int_t, :bool, :BOOL]
    SIZE = [0].pack("i_").size

    def initialize(name, opts={})
      super(name, SIZE, "i_")
    end
  end

  class Uint < PackedType
    register [:uint, :uint_t, :unsigned_int]
    SIZE = [0].pack("I_").size

    def initialize(name, opts={})
      super(name, SIZE, "I_")
    end
  end

  class Short < PackedType
    register [:short, :short_t]
    SIZE = [0].pack("s_").size

    def initialize(name, opts={})
      super(name, SIZE, "s_")
    end
  end

  class Ushort < PackedType
    register [:ushort, :ushort_t, :unsigned_short]
    SIZE = [0].pack("S_").size
    def initialize(name, opts={})
      super(name, SIZE, "S_")
    end
  end

  class Long < PackedType
    register [:long, :long_t]
    SIZE = [0].pack("l_").size
    def initialize(name, opts={})
      super(name, SIZE, "l_")
    end
  end

  class Ulong < PackedType
    register [:ulong, :ulong_t, :unsigned_long]
    SIZE = [0].pack("L_").size
    def initialize(name, opts={})
      super(name, SIZE, "L_")
    end
  end

  class Int16 < PackedType
    register [:int16, :int16_t, :i16, :i16_t]
    def initialize(name, opts={})
      super(name, 2, "s")
    end
  end

  class Uint16 < PackedType
    register [:uint16, :uint16_t, :u16, :u16_t, :unsigned_int16]
    def initialize(name, opts={})
      super(name, 2, "S")
    end
  end

  class Int32 < PackedType
    register [:int32, :int32_t, :i32, :i32_t]
    def initialize(name, opts={})
      super(name, 4, "l")
    end
  end

  class Uint32 < PackedType
    register [:uint32, :uint32_t, :u32, :u32_t, :unsigned_int32]
    def initialize(name, opts={})
      super(name, 4, "L")
    end
  end

  class Int64 < PackedType
    register [:int64, :int64_t, :i64, :i64_t]
    def initialize(name, opts={})
      super(name, 8, "q")
    end
  end

  class Uint64 < PackedType
    register [:uint64, :uint64_t, :u64, :u64_t, :unsigned_int64]
    def initialize(name, opts={})
      super(name, 8, "Q")
    end
  end

  class Uint16le < PackedType
    register [:uint16le, :uint16_le, :ul16, :le16, :unsigned_int16le]
    def initialize(name, opts={})
      super(name, 8, "v")
    end
  end

  class Uint16be < PackedType
    register [:uint16be, :uint16_be, :ub16, :be16, :unsigned_int16be]
    def initialize(name, opts={})
      super(name, 8, "n")
    end
  end

  class Uint32le < PackedType
    register [:uint32le, :uint32_le, :ul32, :le32, :unsigned_int32le]
    def initialize(name, opts={})
      super(name, 8, "V")
    end
  end

  class Uint32be < PackedType
    register [:uint32be, :uint32_be, :ub32, :be32, :unsigned_int32be]
    def initialize(name, opts={})
      super(name, 8, "N")
    end
  end

  class Pointer < PackedType
    register
    SIZE = [0].pack("L_").size

    def initialize(name, typ, opts={})
      super(name, SIZE, "L_")
    end
  end
end
