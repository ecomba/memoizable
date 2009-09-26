require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Memoizable" do
  before(:all) do
    class Foo; def a; return "blaah" end; end;
  end
  
  context "Module structure" do
    it "should have a ClassMethods module" do
      Memoizable::ClassMethods.class.should be(Module)
    end
    
    it "should contain a memonize method" do
      Memoizable::ClassMethods.public_method_defined?(:memoize).should be_true
    end
    
    context ": Cache" do
      it "should be present" do
        Memoizable::CACHE.should_not be_nil
      end
      
      it "should be a hash" do
        Memoizable::CACHE.should be_instance_of(Hash)
      end
    end
  end
  
  context "Class Inclusion" do
    it "should extend a given class with the memoize method" do
      class Foo; include Memoizable; end;
      Foo.respond_to?(:memoize).should be_true
    end
    
    it "should alias the original method" do
      Foo.memoize :a
      foo = Foo.new
      foo.respond_to?("__original__a").should be_true
    end
    
    it "should modify the method" do
      method_a = Foo.instance_method(:a)
      Foo.memoize :a
      method_a.should_not == Foo.instance_method(:a)
    end
  end
  
  context "Method calls" do  
    it "should return the same values" do
      foo = Foo.new
      first_return = foo.a
      Foo.memoize :a
      first_return.should == foo.a
    end
    
    it "should put the method call into the cache" do
      Foo.memoize :a
      foo = Foo.new
      Memoizable::CACHE.size.should > 0
    end
  end
end
