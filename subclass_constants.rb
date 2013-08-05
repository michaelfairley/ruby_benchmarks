require 'benchmark'

class Super
  def constget
    self.class.const_get(:THING)
  end

  def explicit
    self.class::THING
  end

  def ivar
    @thing
  end
end

class SubA < Super
  @thing = THING = 123
end

class SubB < Super
  @thing = THING = 456
end

subs = 10000.times.map{ SubA.new } + 10000.times.map{ SubB.new }

Benchmark.bmbm(10) do |x|
  x.report("const_get") do
    1000.times{ subs.map(&:constget) }
  end
  x.report("explicit") do
    1000.times{ subs.map(&:explicit) }
  end
  x.report("ivar") do
    1000.times{ subs.map(&:ivar) }
  end
end
