require 'rstruct/registry'

module Rstruct
  class Type
    module ClassMethods
      def instance(*args)
        new(*args)
      end

      def to_sym
        self.name.to_s.split('::').last.gsub(/(^|[a-z])([A-Z])/) do 
          ($1.empty?)? $2 : "#{$1}_#{$2}"
        end.downcase.to_sym
      end

      def register(names=nil, reg=nil)
        names ||= to_sym
        reg ||= Registry::DEFAULT_REGISTRY
        reg.register(self, *names)
      end
    end

    def self.inherited(base)
      base.extend(ClassMethods)
    end

    attr_reader :name, :size, :format

    def initialize(name, size, format)
      @name = name.to_sym
      @size = size
      @format = format
    end

  end

end

