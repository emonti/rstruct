require 'rstruct/base_types'

module Rstruct
  Char = PackedType.new(:char, 1, "A", :alias => [:char, :char_t])

  Byte = PackedType.new(:byte, 1, "c", :alias => [:BYTE, :signed_byte])

  Ubyte = PackedType.new(:ubyte, 1, "C", :alias => [:UBYTE, :unsigned_byte])

  Pointer = PackedType.new(:pointer, [0].pack("L_").size , "L_", :alias => :pointer)

  Int = PackedType.new(:int, [0].pack("i_").size, "i_", :alias => [:int_t, :bool, :BOOL, :signed_int])

  Uint = PackedType.new(:uint, [0].pack("I_").size, "I_", :alias => [:uint_t, :unsigned_int])

  Short = PackedType.new(:short, [0].pack("s_").size, "s_", :alias => [:short_t, :signed_short])

  Ushort = PackedType.new(:ushort, [0].pack("S_").size, "S_", :alias => [:ushort_t, :unsigned_short])

  Long = PackedType.new(:long, [0].pack("l_").size, "l_", :alias => [:long_t, :signed_long])

  Ulong = PackedType.new(:ulong, [0].pack("L_").size, "L_", :alias => [:ulong_t, :unsigned_long])

  Int16 = PackedType.new(:int16, 2, 's', :alias => [:int16_t, :i16, :i16_t, :signed_int16])

  Uint16 = PackedType.new(:uint16, 2, 'S', :alias => [:uint16_t, :u16, :u16_t, :unsigned_int16])

  Int32 = PackedType.new(:int32, 4, "l", :alias => [:int32_t, :i32, :i32_t, :signed_int32])

  Uint32 = PackedType.new(:uint32, 4, "L", :alias => [:uint32_t, :u32, :u32_t, :unsigned_int32])

  Int64 = PackedType.new(:int64, 8, "q", :alias => [:int64_t, :i64, :i64_t, :signed_int64])

  Uint64 = PackedType.new(:uint64, 8, "Q", :alias => [:uint64_t, :u64, :u64_t, :unsigned_int64])

  Uint16le = PackedType.new(:uint16le, 2, "v", :alias => [:uint16_le, :ul16, :le16])

  Uint32le = PackedType.new(:uint32le, 4, "V", :alias => [:uint32_le, :ul32, :le32])

  Uint16be = PackedType.new(:uint16be, 2, "n", :alias => [:uint16_be, :ub16, :be16])

  Uint32be = PackedType.new(:uint32be, 4, "N", :alias => [:uint32_be, :ub32, :be32])
end
