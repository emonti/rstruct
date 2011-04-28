require 'rstruct/base_types/type'

module Rstruct

  class ContainerType < Type
    def value
      self.container.to_a
    end

    def []=(k,v)
      self.container[k]=v
    end

    def [](k)
      self.container[k]
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
  end

end
