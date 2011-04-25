require 'rstruct/registry'
require 'rstruct/type'
require 'rstruct/types'
require 'rstruct/structure'

module Rstruct
  module ClassMethods
    def struct(*args,&block)
      Rstruct::Structure.new(*args,&block)
    end

    def default_registry
      Registry::DEFAULT_REGISTRY
    end
  end

  extend(ClassMethods)
end

