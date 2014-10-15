require_relative '../../lib/micro_bench'
require_relative 'country_codes'

# This function returns the name of a country for an ISO3166-1 alpha-3 code.
# If you pass a valid country name, it will just return that instead.
# The look up is case-insensitive.

module Locale
  module_function

  def country_name(lookup)
    matches = COUNTRY_CODE_MAP.select do |code, country|
      [code.downcase, country.downcase].include? lookup.downcase
    end
    matches.first.last if matches.any?
  end

  def lazy_country_name(lookup)
    match = COUNTRY_CODE_MAP.find do |code, country|
      [code.downcase, country.downcase].include? lookup.downcase
    end
    match.last if match
  end

  def keyed_country_name(lookup)
    lookup = lookup.upcase
    COUNTRY_CODE_MAP[lookup] or COUNTRY_CODE_MAP.each_value.find do |v|
      v.upcase == lookup
    end
  end

  def casecmp_country_name(lookup)
    COUNTRY_CODE_MAP[lookup.upcase] or COUNTRY_CODE_MAP.values.find do |v|
      v.casecmp(lookup) == 0
    end
  end

end

100.times { Locale.keyed_country_name 'denmark' }
#exit

b = MicroBench.new Locale, 'denmark', {
  'NZL'         => 'New Zealand',
  'nzl'         => 'New Zealand',
  'New Zealand' => 'New Zealand',
  'new zealand' => 'New Zealand',
  'foo'         => nil,
}

b.check :country_name, :lazy_country_name, :keyed_country_name, :casecmp_country_name
