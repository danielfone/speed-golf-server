require_relative '../../lib/micro_bench'
require_relative 'country_codes'

module Locale
  module_function

  def country_name(lookup)
    COUNTRY_CODE_MAP[lookup.upcase] or COUNTRY_CODE_MAP.values.find {|c|c.casecmp(lookup) == 0}
  end

  def slower0(lookup)
    lookup = lookup.upcase
    COUNTRY_CODE_MAP[lookup] or COUNTRY_CODE_MAP.each_value.find do |country|
      country.upcase == lookup
    end
  end

  def slower(lookup)
    COUNTRY_CODE_MAP.each do |code,country|
      return country if [code.downcase, country.downcase].include? lookup.downcase
    end
    nil
  end

  def slower2(lookup)
    matches = COUNTRY_CODE_MAP.select do |code, country|
      [code.downcase, country.downcase].include? lookup.downcase
    end
    matches.first.last if matches.any?
  end


end

100.times { Locale.slower0 'denmark' }
100.times { Locale.country_name 'denmark' }

exit

b = MicroBench.new Locale, 'denmark', {
  'NZL'         => 'New Zealand',
  'nzl'         => 'New Zealand',
  'New Zealand' => 'New Zealand',
  'new zealand' => 'New Zealand',
  'foo'         => nil,
}

b.check :country_name, :slower, :slower2, :slower0
