require 'benchmark/ips'

def benchmark(object, arg, *methods)
  Benchmark.ips do |x|
    x.time = 0.5
    x.warmup = 0.1

    methods.each do |m|
      x.report(m.to_s) { object.public_send m, arg }
    end

    x.compare!
  end
end



module Fibonacci
  module_function

  def recursive(n)
    n <= 1 ? n : recursive(n-1) + recursive(n-2)
  end

end

puts Fibonacci.recursive 10

benchmark Fibonacci, 10, :recursive