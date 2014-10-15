require_relative '../../lib/micro_bench'

module Adder
  module_function

  def scan_block(text)
    total = 0
    text.scan(/[\d,\.]+/).each do |number|
      bare_number = number.gsub(/,/, '') # remove thousands separater
      total += bare_number.to_f
    end
    total
  end

  def scan(text)
    text.scan(/[\d,\.]+/).map { |s| s.delete ',' }.map(&:to_f).reduce(0, :+)
  end

  def split(text)
    text.delete(',').split.map(&:to_f).reduce(0, :+)
  end


end

TEXT = <<-EOF
   4, 8, 15, 16, 23 and 42
   # >>  0.850000   0.000000   0.850000 (  0.859678)
   1,138
EOF

b = MicroBench.new Adder, TEXT*10, {
  "4, 8, 15, 16, 23 and 42" => 108.0,
  "1,123" => 1123,
  "0.10001, 1.0" => 1.10001,
}
b.check :scan, :scan_block, :split
