$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'rstruct'

module Pe
  extend Rstruct::ClassMethods

  PE_REGISTRY = Rstruct::Registry.new(:portable_executable)

  def self.registry
    PE_REGISTRY
  end

  typedef :uint16le, :WORD, :register => registry()
  typedef :uint32le, :LONG, :register => registry()
  typedef :uint32le, :DWORD, :register => registry()

  IMAGE_DOS_HEADER = struct(:IMAGE_DOS_HEADER, :register => registry()) {
     WORD :magic    # magic number
     WORD :cblp     # bytes on last page of file
     WORD :cp       # pages in file
     WORD :crlc     # relocations
     WORD :cparhdr  # size of header in paragraphs
     WORD :minalloc # minimum extra paragraphs needed
     WORD :maxalloc # maxumum extra paragraphs needed
     WORD :ss       # Initial (relative) SS value
     WORD :sp       # Initial SP value
     WORD :csum     # Checksum
     WORD :ip       # Initial IP value
     WORD :cs       # Initial (relative) CS value
     WORD :lfarlc   # File address of relocation table
     WORD :ovno     # overlay number
     array :res1, :uint16le, 4
     WORD :oemid    # OEM identifier
     WORD :oeminfo  # OEM information; oem specific
     array :res2, :uint16le, 10
     LONG :lfanew   # File address of new exe header (PE header)
  }



  IMAGE_FILE_MACHINE_TYPES = {
    0 => :UNKNOWN,
    0x014C => :I386,
    0x8664 => :AMD64,
    0x01C0 => :ARM,
    0x0162 => :R3000,
    0x0166 => :R4000,
    0x0168 => :R10000,
    0x0169 => :WCEMIPSV2,
    0x0184 => :ALPHA,
    0x01A2 => :SH3,
    0x01A3 => :SH3DSP,
    0x01A4 => :SH3E,
    0x01A6 => :SH4,
    0x01A8 => :SH5,
    0x01C2 => :THUMB,
    0x01D3 => :AM33,
    0x01F0 => :POWERPC,
    0x01F1 => :POWERPCFP,
    0x0200 => :IA64,
    0x0266 => :MIPS16,
    0x0284 => :ALPHA64,
    0x0366 => :MIPSFPU,
    0x0466 => :MIPSFPU16,
    0x0520 => :TRICORE,
    0x0CEF => :CEF,
    0x0EBC => :EBC,
    0x9041 => :M32R,
    0xC0EE => :CEE,
  }

  IMAGE_FILE_CHARACTERISTICS_FLAGS = {
    :RELOCS_STRIPPED          => 0x0001,
    :EXECUTABLE_IMAGE         => 0x0002,
    :LINE_NUMS_STRIPPED       => 0x0004,
    :LOCAL_SYMS_STRIPPED      => 0x0008,
    :AGGRESIVE_WS_TRIM        => 0x0010,
    :LARGE_ADDRESS_AWARE      => 0x0020,
    :BYTES_REVERSED_LO        => 0x0080,
    :MACHINE_32BIT            => 0x0100,
    :DEBUG_STRIPPED           => 0x0200,
    :REMOVABLE_RUN_FROM_SWAP  => 0x0400,
    :NET_RUN_FROM_SWAP        => 0x0800,
    :SYSTEM                   => 0x1000,
    :DLL                      => 0x2000,
    :UNIPROC_SYSTEM_ONLY      => 0x4000,
    :BYTES_REVERSED_HI        => 0x8000,
  }

  IMAGE_FILE_HEADER = struct(:IMAGE_FILE_HEADER, :register => registry()) {
    WORD  :Machine
    WORD  :NumberOfSections
    DWORD :TimeDateStamp
    DWORD :PointerToSymbolTable
    DWORD :NumberOfSymbols
    WORD  :SizeOfOptionalHeader
    WORD  :Characteristics
  }

  IMAGE_DATA_DIRECTORY = struct(:IMAGE_DATA_DIRECTORY, :register => registry()) {
    DWORD :VirtualAddress
    DWORD :Size
  }

  IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16

  IMAGE_NT_OPTIONAL_HDR_MAGIC = {
    0x10b => :HDR32,
    0x20b => :HDR64,
    0x107 => :ROM,
  }

  IMAGE_NT_OPTIONAL_HDR_SUBSYSTEMS = [
    :UNKNOWN,
    :NATIVE,
    :WINDOWS_GUI,
    :WINDOWS_CONSOLE,
    nil,
    :OS2_CONSOLE,
    nil,
    :POSIX_CONSOLE,
    :NATIVE_WIN9X_DRIVER,
    :WINDOWS_CE_GUI,
    :EFI_APPLICATION,
    :EFI_BOOT_SERVICE_DRIVER,
    :EFI_RUNTIME_DRIVER,
    :EFI_ROM,
    :XBOX,
    nil,
    :WINDOWS_BOOT_APPLICATION,
  ]

  IMAGE_DLL_CHARACTERISTICS_FLAGS = {
    :DYNAMIC_BASE    => 0x0080,
    :FORCE_INTEGRITY => 0x0080,
    :NX_COMPAT       => 0x0100,
    :NO_ISOLATION    => 0x0200,
    :NO_SEH          => 0x0400,
    :NO_BIND         => 0x0800,
    :WDM_DRIVER      => 0x2000,
    :TERM_SVR_AWARE  => 0x8000,
  }

  IMAGE_OPTIONAL_HEADER = struct(:IMAGE_OPTIONAL_HEADER, :register => registry()) {
    WORD  :Magic
    BYTE  :MajorLinkerVersion
    BYTE  :MinorLinkerVersion
    DWORD :SizeOfCode
    DWORD :SizeOfInitializedData
    DWORD :SizeOfUninitializedData
    DWORD :AddressOfEntryPoint
    DWORD :BaseOfCode
    DWORD :BaseOfData
    DWORD :ImageBase
    DWORD :SectionAlignment
    DWORD :FileAlignment
    WORD  :MajorOperatingSystemVersion
    WORD  :MinorOperatingSystemVersion
    WORD  :MajorImageVersion
    WORD  :MinorImageVersion
    WORD  :MajorSubsystemVersion
    WORD  :MinorSubsystemVersion
    DWORD :Win32VersionValue
    DWORD :SizeOfImage
    DWORD :SizeOfHeaders
    DWORD :CheckSum
    WORD  :Subsystem
    WORD  :DllCharacteristics
    DWORD :SizeOfStackReserve
    DWORD :SizeOfStackCommit
    DWORD :SizeOfHeapReserve
    DWORD :SizeOfHeapCommit
    DWORD :LoaderFlags
    DWORD :NumberOfRvaAndSizes

    IMAGE_DATA_DIRECTORY :DDExportTable
    IMAGE_DATA_DIRECTORY :DDImportTable
    IMAGE_DATA_DIRECTORY :DDResourceTable
    IMAGE_DATA_DIRECTORY :DDExceptionTable
    IMAGE_DATA_DIRECTORY :DDCertificatTable
    IMAGE_DATA_DIRECTORY :DDBaseRelocationTable
    IMAGE_DATA_DIRECTORY :DDDebuggingInformation
    IMAGE_DATA_DIRECTORY :DDArchSpecificData
    IMAGE_DATA_DIRECTORY :DDGlobalPointerRegisterRVA
    IMAGE_DATA_DIRECTORY :DDTlsTable
    IMAGE_DATA_DIRECTORY :DDLoadConfigurationTable
    IMAGE_DATA_DIRECTORY :DDBoundImportTable
    IMAGE_DATA_DIRECTORY :DDImportAddressTable
    IMAGE_DATA_DIRECTORY :DDDelayImportDescriptor
    IMAGE_DATA_DIRECTORY :DDClrHeader
    IMAGE_DATA_DIRECTORY :DDReserved
  }

  IMAGE_NT_HEADERS = struct(:IMAGE_NT_HEADERS, :register => registry()) {
    DWORD                 :Signature
    IMAGE_FILE_HEADER     :FileHeader
    IMAGE_OPTIONAL_HEADER :OptionalHeader
  }

  IMAGE_SIZEOF_SHORT_NAME = 8

  IMAGE_SECTION_HEADER = struct(:IMAGE_SECTION_HEADER, :register => registry()) {
    array :Name, :char, 8
    DWORD :PhysicalAddress
    DWORD :VirtualAddress
    DWORD :SizeOfRawData
    DWORD :PointerToRawData
    DWORD :PointerToRelocations
    DWORD :PointerToLinenumbers
    WORD  :NumberOfRelocations
    WORD  :NumberOfLinenumbers
    DWORD :Characteristics
  }

  def self.parse_header(*args)
    Headers.new(*args)
  end

  class Headers
    attr_reader :dos, :stub, :coff, :sections, :file_data

    def initialize(input, param = {})
      input = StringIO.new(input) if input.is_a?(String)
      @dos      = IMAGE_DOS_HEADER.read(input)
      @stub     = input.read(@dos.lfanew - IMAGE_DOS_HEADER.sizeof)
      @coff     = IMAGE_NT_HEADERS.read(input)
      @sections = Array.new(@coff.FileHeader.NumberOfSections) do 
       IMAGE_SECTION_HEADER.read(input)
      end
    end

    # Returns a Time object representation of the 
    # PE header timestamp.
    def timestamp
      Time.at(coff.FileHeader.TimeDateStamp)
    end

    # Returns the size of the PE file based on header
    # information. Specifically, the last section's 
    # PointerToRawData is added to its SizeOfRawData
    # which should be equal to the file size.
    def file_size
      lseg = self.sections.last
      lseg.PointerToRawData + lseg.SizeOfRawData
    end

    def repack(io=nil)
      io ||= StringIO.new
      self.dos.write(io)
      io.write(self.stub)
      self.coff.write(io)
      self.sections.each{ |s| s.write(io) }
      io.string if io.is_a?(StringIO)
    end

    # the checksum value from the parsed header
    def checksum
      coff.OptionalHeader.CheckSum
    end

  end
end
