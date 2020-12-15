require_relative 'mask'

class Memory
  attr_reader :mask
  attr_reader :memory

  def initialize
    @memory = {}
    @mask = Mask.new
  end

  def set_memory(idx, value)
    @memory[idx] = mask.apply(value)
  end

  def memory_sum
    memory.map(&:last).sum
  end
end
