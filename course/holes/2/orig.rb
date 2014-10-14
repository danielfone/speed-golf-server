module Adder
  module_function

  def orig_sum(numbers)
    running_total = 0
    floats = Array(numbers).map(&:to_f)
    floats.each do |f|
      running_total = running_total + f
    end
    running_total
  end

end