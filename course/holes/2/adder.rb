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


module Adder
  module_function

  def adder(text)
    text.scan(/[\d,\.]+/).map { |s| s.delete ',' }.map(&:to_f).reduce(0, :+)
  end

end

TEXT = <<-EOF
   4, 8, 15, 16, 23 and 42

   # >>  0.850000   0.000000   0.850000 (  0.859678)
   # >>  0.630000   0.000000   0.630000 (  0.638381)
   # >>  0.510000   0.000000   0.510000 (  0.502865)
   # >>  0.710000   0.010000   0.720000 (  0.721911)
   # >>
   # >>      user     system      total        real
   # >>  0.770000   0.000000   0.770000 (  0.773135)
   # >>  0.620000   0.000000   0.620000 (  0.627442)
   # >>  0.490000   0.000000   0.490000 (  0.497729)
   # >>  0.700000   0.000000   0.700000 (  0.704367)

   1,138
EOF

benchmark Adder, TEXT, *[
  :adder,
]