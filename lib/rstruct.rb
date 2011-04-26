require 'rstruct/registry'
require 'rstruct/type'
require 'rstruct/types'
require 'rstruct/structure'
require 'rstruct/struct_builder'

module Rstruct
  module ClassMethods
    # TODO doc
    # The DSL interface for this method is implemented by
    # Rstruct::StructBuilder.
    def struct(name, opts={},&block)
      Rstruct::Structure.new(name, opts, &block)
    end

    # Just like struct, but it uses a DSL format like C-structs where types
    # are followed by their names.
    #
    # The DSL interface for this method is implemented by
    # Rstruct::CstructBuilder.
    def cstruct(name, opts={}, &block)
      Rstruct::Structure.new(name,opts.merge(:builder => CstructBuilder, &block)
    end

    # Returns the default Rstruct registry
    def default_registry
      Registry::DEFAULT_REGISTRY
    end
  end

  extend(ClassMethods)
end

