#!/usr/bin/env ruby
# A basic Rstruct example using Apple's FAT file structure.
# To compare the structs to their C counterparts, see:
#   http://fxr.watson.org/fxr/source/EXTERNAL_HEADERS/mach-o/fat.h?v=xnu-1228

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'rstruct'
extend Rstruct::ClassMethods

FAT_MAGIC = 0xcafebabe
FAT_CIGAM = 0xbebafeca

fat_header = struct(:fat_header) {
  uint32be  :magic;      # FAT_MAGIC
  uint32be  :nfat_arch;  # number of structs that follow
}

typedef :uint32be, :cpu_type_t
typedef :uint32be, :cpu_subtype_t

fat_arch = struct(:fat_arch) {
  cpu_type_t     :cputype    # cpu specifier (int)
  cpu_subtype_t  :cpusubtype # machine specifier (int)
  uint32be       :offset     # file offset to this object file
  uint32be       :size       # size of this object file
  uint32be       :align      # alignment as a power of 2
}

typedef :uint32le, :cpu_type_le
typedef :uint32le, :cpu_subtype_le

mach_header = struct(:mach_header) { # little endian this time
  uint32le       :magic      # mach magic number identifier
  cpu_type_le    :cputype    # cpu specifier
  cpu_subtype_le :cpusubtype # machine specifier
  uint32le       :filetype   # type of file
  uint32le       :ncmds      # number of load commands
  uint32le       :sizeofcmds # the size of all the load commands
  uint32le       :flags      # flags
}

# a basic helper to produce textual dumps of fields
def dump(struct)
  struct.each_pair.map {|k,v| "  #{k} = 0x%0.8x" % v}
end

ARGV.each do |fname|
  File.open(fname,'r') do |f|

    # Read and dump the FAT header from the file
    head = fat_header.read(f)
    unless [FAT_MAGIC, FAT_CIGAM].include?(head.magic)
      STDERR.puts "Error: #{fname} does not look like a FAT binary"
      next
    end
    puts "File: #{fname}", "FAT header:", dump(head)
    puts

    # parse the architectures located after the FAT header
    (head.nfat_arch).times do |i|
      arch = fat_arch.read(f)
      puts "  Architecture #{i}:"
      puts "  " << dump(arch).join("\n  ")
      puts

      # dump the mach header
      opos = f.pos        # save our file position so we get the next arch
      f.pos = arch.offset # jump to where the mach header should be
      mach = mach_header.read(f)  # parse a mach_header struct
      f.pos = opos # return to saved architecture position

      puts "    Mach Header:"
      puts "    " << dump(mach).join("\n    ")
      puts

    end
  end
end
