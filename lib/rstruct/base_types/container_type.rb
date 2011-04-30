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

    def write(dst=nil, pvals=nil)
      if dst.is_a?(String)
        l = dst.size
        dst = StringIO.new(dst)
        dst.pos = l
      elsif dst.nil?
        dst = StringIO.new
      end

      typ ||= self.rstruct_type


      vals = (pvals.respond_to?(:values) ? pvals.values : pvals)
      vals ||= self.values

      opos = dst.pos
      typ.fields.each_with_index do |f, i|
        fldval = vals[i]
        if fldval.respond_to?(:write)
          fldval.write(dst, fldval)
        else
          dst.write(f.typ.pack_value(fldval, self))
        end
      end
      if dst.is_a?(StringIO) and pvals.nil?
        dst.pos = opos
        return(dst.read)
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

    def sizeof
      self.fields.inject(0) do |s,v| 
        if vs=v.typ.sizeof
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

    def read(raw)
      raw = StringIO.new(raw) if raw.is_a?(String)
      obj = self.instance()
      fields.each do |f|
        obj[f.name] = 
          if f.respond_to?(:read)
            f.read(raw)
          else
            f.unpack_raw(raw, obj)
          end
      end
      return obj
    end
  end

end
