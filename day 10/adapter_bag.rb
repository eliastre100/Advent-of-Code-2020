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

  def count_possible_arrangements
    target = Adapter.new(adapters.last.joltage + 3)
    outlet = Adapter.new(0)
    relation_map = {}
    (adapters + [outlet]).each do |adapter|
      relation_map[adapter] = { paths: nil, adapters: adapters.select { |tested_adaper| tested_adaper.joltage != adapter.joltage && tested_adaper.can_plug?(adapter) } }
    end
    count_paths(outlet, relation_map, target)
  end
  
  private
  
  def count_paths(adapter, relation_map, target)
    relation_item = relation_map[adapter]
    return relation_item[:paths] unless relation_item[:paths].nil?

    direct_link_bonus = target.can_plug?(adapter) ? 1 : 0
    indirect_links = relation_item[:adapters].map { |adapter| count_paths(adapter, relation_map, target) }.reduce(&:+) || 0
    relation_item[:paths] = direct_link_bonus + indirect_links
  end
end
