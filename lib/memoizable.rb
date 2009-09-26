module Memoizable
  CACHE = Hash.new
  module ClassMethods
    def memoize(name)
      original = "__original__#{name}"
      alias_method original, name
      define_method(name) do |*args|
        CACHE[self.to_s.unpack("a*")<<name.to_s.unpack("a*")<<args] ||= 
          send(original, *args)
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end