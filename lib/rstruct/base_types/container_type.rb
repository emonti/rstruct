require 'rstruct/base_types/type'

module Rstruct

  module ContainerMixins
    def rstruct_type
      @rstruct_type
    end

    def rstruct_type=(val)
      if @rstruct_type
        raise(ArgumentError, "Can't override the rstruct_type once it is set")
      else
        @rstruct_type = val
      end
    end

    def put(dst=nil, pvals=nil)
      dst ||= StringIO.new
      typ ||= self.rstruct_type
      vals = pvals || self.values

      opos = dst.pos
      typ.fields.each_with_index do |f, i|
        fldval = vals.shift
        if self.values[i].respond_to?(:put)
          self.values[i].put(dst, fldval.values)
        else
          dst.write(f.typ.pack_value(fldval, self))
        end
      end
      if dst.is_a?(StringIO) and pvals.nil?
        return(dst.string)
      else
        return dst.pos - opos
      end
    end
  end

  class ContainerType < Type
    include Packable

    def initialize(*args, &block)
      @countainer = true
      super(*args, &block)
    end

    def groupable?
      self.fields.find {|f| not f.groupable? }.nil?
    end

    def format
      self.fields.map do |f| 
        if f.groupable?
          f.format 
        else
          return nil
        end
      end.join
    end

    def size
      self.fields.inject(0) do |s,v| 
        if vs=v.size
          s+=vs
        else
          return nil
        end
      end
    end

    def field_names
      @field_names ||= self.fields.map{|f| f.name }
    end

    def field_types 
      @field_types ||= self.fields.map{|f| f.typ }
    end

  end

end
