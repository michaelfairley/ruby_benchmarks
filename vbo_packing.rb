require "benchmark"

class Thing
  def initialize(n)
    @n = n
  end

  def values
    [@n, @n, @n, @n, @n, @n]
  end
end

things = 100000.times.map{|i| Thing.new(i) }

Benchmark.bmbm(10) do |x|
  x.report("flat_map") { 10.times { things.flat_map(&:values).pack('f*') } }
  x.report("join") { 10.times { things.map{|t| t.values.pack('f*')}.join } }
  x.report("concat") { 10.times { things.each_with_object("") {|t,s| s << t.values.pack('f*') } } }
end
