class AdapterBag
  attr_reader :adapters

  def initialize
    @adapters = []
  end

  def add_adapter(adapter)
    @adapters << adapter
    @adapters.sort_by!(&:joltage)
  end

  def applied_tension_differences
    tension_differences = { "#{adapters.first.joltage}": 1 }
    adapters.each_cons(2) do |previous_adapter, next_adapter|
      joltage_difference_key = (next_adapter.joltage - previous_adapter.joltage).to_s.to_sym
      tension_differences[joltage_difference_key] = (tension_differences[joltage_difference_key] || 0) + 1
    end
    tension_differences
  end
end
