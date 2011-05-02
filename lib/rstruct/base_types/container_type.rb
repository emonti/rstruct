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

      opos = dst.pos if dst.respond_to?(:pos)
      typ.fields.each_with_index do |f, i|
        fldval = vals[i]
        if fldval.respond_to?(:write)
          fldval.write(dst, fldval)
        else
          dst.write(f.typ.pack_value((fldval || 0), self))
        end
      end
      if dst.is_a?(StringIO) and pvals.nil?
        dst.pos = opos
        return(dst.read)
      elsif opos and dst.respond_to?(:pos)
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
      self.fields.map{|f| f.name }
    end

    def field_types 
      self.fields.map{|f| f.typ }
    end

    def read(raw, obj=nil)
      raw = StringIO.new(raw) if raw.is_a?(String)
      obj = self.instance()
      fields.each do |f|
        obj[f.name] = f.typ.read(raw, obj)
      end
      return obj
    end

    def claim_value(vals, obj=nil)
      if @claim_cb
        @claim_cb.call(vals, obj)
      else
        # create our struct container
        s = instance()

        # iterate through the fields assigning values in the
        # container and pass it along with values to each
        # field's claim_value method.
        self.fields.do {|f| s[f.name] = f.typ.claim_value(vals,s) }
        return s
      end
    end
  end

end
