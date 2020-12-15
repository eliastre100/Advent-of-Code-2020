require_relative 'mask'
require_relative 'address_mask'

class Memory
  attr_reader :mask
  attr_reader :memory
  attr_reader :mask_use

  SET_HANDLERS = {
    value: :set_memory_value,
    address: :set_memory_address
  }

  def initialize(mask_use = :value)
    @memory = {}
    @mask = mask_use == :value ? Mask.new : AddressMask.new
    @mask_use = mask_use
  end

  def set_memory(address, value)
    method(SET_HANDLERS[@mask_use]).call(address, value)
  end

  def memory_sum
    memory.map(&:last).sum
  end

  private

  def set_memory_value(address, value)
    @memory[address] = mask.apply(value)
  end

  def set_memory_address(address, value)
    mask.apply(address).each do |address|
      memory[address] = value
    end
  end
end
