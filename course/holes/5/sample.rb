require_relative '../../lib/micro_bench'

# Randomly return half the numbers under the provided limit
# e.g.
#   sample_half(10) => [1,3,4,5,8]
#   sample_half(4) => [2,3]
#
# Things that don't matter:
#   - order
#   - inclusive/exclusive of 0 and the limit
#
# Things that do matter:
#   - passing the test
#   - returning the right number of elements
#   - all returned elements are UNIQUE
#   - being random (no, you can't test this. I'll be checking any winning algorithms)
#
# One rule: this is a BYO entropy challenge,
#           you may not use use #sample or #shuffle
#
# ~30x improvement available

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
    population = (1..limit).to_a
    sample = []
    count.times do |i|
      random_index = rand population.size
      sample << population.delete_at(random_index)
    end
    sample
  end

  def upto(limit)
    count = limit/2
    jump = 2
    sample = {}
    i = 0
    count.times do
      i += @prng.rand(jump)+1
      sample[i % limit] = true
    end
    sample.keys
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
#  :sample_half,
  :del,
  :hash,
  :hash2,
  :set,
  :upto,
]

#Sample.hash2 10000
#Sample.upto 100000
##Sample.set 100000
#exit

TEST_METHODS.each do |m|
  limit = 100
  count = limit / 2
  res = Sample.public_send m, limit
  uniq_count = res.uniq.count
  fail "[#{m}] returned #{uniq_count} uniq elements, expected #{count}" if uniq_count != count
end

b = MicroBench.new Sample, 100000, {}
b.check *TEST_METHODS
