require 'stringio'
require 'rstruct/registry'
require 'rstruct/types'
require 'rstruct/structure'
require 'rstruct/struct_builder'

module Rstruct
  module ClassMethods

    # Take the following C struct for example:
    #
    #   struct mach_header {
    #     uint32_t      magic;      /* mach magic number identifier */
    #     cpu_type_t    cputype;    /* cpu specifier */
    #     cpu_subtype_t cpusubtype; /* machine specifier */
    #     uint32_t      filetype;   /* type of file */
    #     uint32_t      ncmds;      /* number of load commands */
    #     uint32_t      sizeofcmds; /* the size of all the load commands */
    #     uint32_t      flags;      /* flags */
    #   }
    #
    # Which might be defined with rstruct as follows:
    #
    #   extend(Rstruct::ClassMethods)
    #
    #   typedef :uint32_t, :cpu_type_t
    #   typedef :uint32_t, :cpu_subtype_t
    #
    #   struct(:mach_header) {
    #     uint32_t      :magic      # mach magic number identifier
    #     cpu_type_t    :cputype    # cpu specifier
    #     cpu_subtype_t :cpusubtype # machine specifier
    #     uint32_t      :filetype   # type of file
    #     uint32_t      :ncmds      # number of load commands
    #     uint32_t      :sizeofcmds # the size of all the load commands
    #     uint32_t      :flags      # flags
    #   }
    #
    def struct(name, opts={},&block)
      Rstruct::Structure.new(name, opts, &block)
    end

    def typedef(p, t, opts={})
      reg = opts[:registry] || default_registry
      reg.typedef(p,t,opts)
    end

    # Returns the default Rstruct registry
    def default_registry
      Registry::DEFAULT_REGISTRY
    end
  end

  extend(ClassMethods)
end

