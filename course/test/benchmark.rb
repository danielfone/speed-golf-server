require 'benchmark/ips'

def benchmark(desc, result, object, method, *args)
  fast_val = object.public_send method, *args
  orig_val = object.public_send "orig_#{method}", *args

  raise "[fast] #{method} #{desc}: #{fast_val.inspect} != #{result.inspect}" unless fast_val == result
  raise "[orig] #{method} #{desc}: #{orig_val.inspect} != #{result.inspect}" unless orig_val == result

  Benchmark.ips do |x|
    x.time = 0.5
    x.warmup = 0.1

    x.report("[fast] #{method} #{desc}") { fast_val = object.public_send method, *args }

    x.report("[orig] #{method} #{desc}") { orig_val = object.public_send "orig_#{method}", *args }

    x.compare!
  end

  raise "#{fast_val} != #{result}" unless fast_val == result
  raise "#{orig_val} != #{result}" unless orig_val == result
end
