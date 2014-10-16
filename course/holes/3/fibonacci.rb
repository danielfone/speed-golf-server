require_relative '../../lib/micro_bench'

# Return the nth fibonacci number
#
# ~300x improvement available
#
# Bonus points: increase n and see if different algorithms perform better

module Fibonacci
  module_function

  def recursive(n)
    n <= 1 ? n : recursive(n-1) + recursive(n-2)
  end

  @fib = [0, 1, 1]
  def memoized(n)
    @fib[n] ||= memoized(n-2) + memoized(n-1)
  end

  def iter(n)
    curr_num, next_num = 0, 1
    (n).times do
      curr_num, next_num = next_num, curr_num + next_num
    end
    curr_num
  end


end

b = MicroBench.new Fibonacci, 15, {
  1 => 1,
  2 => 1,
  3 => 2,
  4 => 3,
  10 => 55,
  15 => 610,
  20 => 6765,
}
b.check :recursive, :memoized, :iter
