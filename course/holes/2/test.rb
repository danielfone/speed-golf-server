require_relative 'orig'
require_relative 'to_fix'

ALL_THE_NUMBERS = 1..1_000

benchmark 'empty', 0, Adder, :sum, []
benchmark 'small', 6, Adder, :sum, [1,2,3]
benchmark 'large', 500500, Adder, :sum, ALL_THE_NUMBERS
