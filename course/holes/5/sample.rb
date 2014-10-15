require_relative '../../lib/micro_bench'

# Can't use #sample or #shuffle

require 'set'

module Sample
  module_function

  def sample_half(limit)
    (1..limit).to_a.sample(limit/2)
  end

  def array(limit)
    count = limit/2
    sample = []
    while sample.count < count
      n = rand limit
      sample << n unless sample.include? n
    end
    sample
  end

  def del(limit)
    count = limit/2
    sample = (1..limit).to_a
    del_index = rand(limit)
    (limit - count).times do |i|
      sample.delete_at(del_index * i % limit-i)
    end
    sample
  end

  def hash(limit)
    count = limit/2
    tmp = nil
    x = {}

    for i in 0...count
        while x.has_key?(tmp = rand(limit))
        end
        x[tmp] = true
    end

    x.keys
  end

  @prng = Random.new
  def hash2(limit)
    count = limit/2
    sample = {}

    while sample.size < count
      sample[@prng.rand(limit)] = true
    end
    sample.keys
  end


  def set(limit)
    count = limit/2
    sample = Set.new
    prng = Random.new
    while sample.size < count
      sample.add prng.rand(limit)
    end
    sample.to_a
  end

end

TEST_METHODS = [
  :sample_half,
#  :array,
  :hash,
  :hash2,
  :set,
]

Sample.hash2 100000

#exit

TEST_METHODS.each do |m|
  limit = 100
  count = limit / 2
  res = Sample.public_send m, limit
  uniq_count = res.uniq.count
  fail "[#{m}] returned #{uniq_count} uniq elements, expected #{count}" if uniq_count != count
end

b = MicroBench.new Sample, 100_000, {}
b.check *TEST_METHODS
