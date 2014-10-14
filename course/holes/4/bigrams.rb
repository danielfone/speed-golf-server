require_relative '../../lib/micro_bench'

# Bigrams are pairs of words found in a text.
#
# This module returns a hash of the pairs and their frequencies.
#
# The text should be normalised, but punctuation will "stop" a bigram. e.g.
#
#   "Hello you how's it?" has 3 bigrams:
#        "hello you"
#        "you hows"
#        "hows it"
#
#   Whereas "Hello you, how's it?" has 2 bigrams:
#        "hello you"
#        "hows it"
#
# See the tests for futher examples

module Bigrams
  module_function

  def parse(text)
    Hash.new(0).tap do |h|
      text.gsub(/[^\w\s]/, '|').downcase.split.each_cons(2) do |n1, n2|
        next if n1.end_with?('|') || n2.start_with?('|')
        key = "#{n1} #{n2}".delete '|'
        h[key] += 1
      end
    end
  end
end

corpus = File.read File.expand_path("../midsummer.txt", __FILE__)

b = MicroBench.new Bigrams, corpus, {

  "and then and then and then" => {
    "and then" => 3,
    "then and" => 2,
  },

  "Hello you, my name is hello you my" => {
    "hello you" => 2,
    "my name"   => 1,
    "name is"   => 1,
    "is hello"  => 1,
    "you my"    => 1,
  },

  "Hello you how's it?" => {
    "hello you" => 1,
    "you hows"  => 1,
    "hows it"   => 1,
  },

  "Hello you, how's it?" => {
    "hello you" => 1,
    "hows it"   => 1,
  },
}

b.check :parse, time: 5
