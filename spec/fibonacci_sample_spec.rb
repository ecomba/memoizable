require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'benchmark'

describe "Fibonacci" do
  class Fibonacci
    def fib(number)
      return number if number < 2
      fib(number -1) + fib(number - 2)
    end
  end
  
  context "context" do
    it "should run faster" do
      fibo = Fibonacci.new
      bm = Benchmark.measure { fibo.fib(30) }
      class Fibonacci; include Memoizable; memoize :fib; end;
      fibo2 = Fibonacci.new
      bm2 = Benchmark.measure { fibo2.fib(30) }
      
      # This test is flakey, I know... How to test the real speed? 
      bm.to_a[5].should > bm2.to_a[5]
      bm2.to_a[5].should < 0.01
    end
  end
end