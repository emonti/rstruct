require 'rstruct/type'

module Rstruct

  class Byte < Type
    register

    def initialize(name, opts={})
      super(name, 1, "C")
    end
  end

  class Char < Type
    register

    def initialize(name, opts={})
      super(name, 1, "A")
    end
  end


  class Int < Type
    register
    SIZE = [0].pack("i_").size

    def initialize(name, opts={})
      super(name, SIZE, "i_")
    end
  end

  class Uint < Type
    register
    SIZE = [0].pack("I_").size

    def initialize(name, opts={})
      super(name, SIZE, "I_")
    end
  end

  class Short < Type
    register
    SIZE = [0].pack("s_").size
    def initialize(name, opts={})
      super(name, SIZE, "s_")
    end
  end

  class Ushort < Type
    register
    SIZE = [0].pack("S_").size
    def initialize(name, opts={})
      super(name, SIZE, "S_")
    end
  end

  class Long < Type
    register
    SIZE = [0].pack("l_").size
    def initialize(name, opts={})
      super(name, SIZE, "l_")
    end
  end

  class Ulong < Type
    register
    SIZE = [0].pack("L_").size
    def initialize(name, opts={})
      super(name, SIZE, "L_")
    end
  end

  class Int16 < Type
    register
    def initialize(name, opts={})
      super(name, 2, "s")
    end
  end

  class Uint16 < Type
    register
    def initialize(name, opts={})
      super(name, 2, "S")
    end
  end

  class Int32 < Type
    register
    def initialize(name, opts={})
      super(name, 4, "l")
    end
  end

  class Uint32 < Type
    register
    def initialize(name, opts={})
      super(name, 4, "L")
    end
  end

  class Int64 < Type
    register
    def initialize(name, opts={})
      super(name, 8, "q")
    end
  end

  class Uint64 < Type
    register
    def initialize(name, opts={})
      super(name, 8, "Q")
    end
  end

  class Uint16le < Type
    register
    def initialize(name, opts={})
      super(name, 8, "v")
    end
  end

  class Uint16be < Type
    register
    def initialize(name, opts={})
      super(name, 8, "n")
    end
  end

  class Uint32le < Type
    register
    def initialize(name, opts={})
      super(name, 8, "V")
    end
  end

  class Uint32be < Type
    register
    def initialize(name, opts={})
      super(name, 8, "N")
    end
  end

end
