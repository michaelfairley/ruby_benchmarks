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
  x.report("flat_map") do
    10.times { things.flat_map(&:values).pack('f*') }
  end
  x.report("join") do
    10.times { things.map{|t| t.values.pack('f*')}.join }
  end
  x.report("concat") do
    10.times { things.each_with_object("") {|t,s| s << t.values.pack('f*') } }
  end
  x.report("prealloc") do
    10.times do
      result = " " * things.size * 6 * 4
      things.each_with_index do |thing, i|
        result[i*24, 24] = thing.values.pack('f*')
      end
    end
  end
end
