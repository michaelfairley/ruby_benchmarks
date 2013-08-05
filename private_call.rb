require 'benchmark'

class Thing
private
  def priv
    1
  end
end

things = 10000.times.map{ Thing.new }

Benchmark.bmbm(13) do |x|
  x.report("send") do
    100.times{ things.each{|t| t.send(:priv) } }
  end
  x.report("instance_eval") do
    100.times{ things.each{|t| t.instance_eval("priv") } }
  end
  x.report("instance_exec") do
    100.times{ things.each{|t| t.instance_exec{priv} } }
  end
  x.report("method") do
    100.times{ things.each{|t| t.method(:priv).call } }
  end
end
