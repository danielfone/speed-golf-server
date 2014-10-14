module Adder
  module_function

  def sum(numbers)
    total = 0
    numbers.each {|n| total += n }
    total
  end

end