require_relative '../../lib/micro_bench'

module StripHeredoc
  module_function

  def unindent_gem(string)
    indent = string.split("\n").select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min || 0
    string.gsub(/^[[:blank:]]{#{indent}}/, '')
  end

  def scan(string)
    indent = string.scan(/^[ \t]*\b/).min
    string.gsub /^#{indent}/,''
  end

  def unindent_by_min_dent(string)
    dent = string.split("\n").reject(&:empty?).map { |line| line[/^\s*/] }.min_by(&:size)
    string.gsub(/^#{dent}/, '')
  end

end

TEXT = <<EOF
   See, the interesting thing about this text
     is that while it seems like the first line defines an indent
       it's actually the last line which has the smallest indent

    there are also some blank lines
  The End.
EOF

b = MicroBench.new StripHeredoc, TEXT*10, {
  "\tabc\n\tabc" => "abc\nabc",
  "x" => "x",
  "  foo\n    bar\n  baz\n" => "foo\n  bar\nbaz\n",
}

b.check :unindent_gem, :scan, :unindent_by_min_dent
