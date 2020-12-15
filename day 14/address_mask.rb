require_relative 'mask'

class AddressMask < Mask
  def initialize
    @mask = '000000000000000000000000000000000000'
  end

  def apply(value)
    binary = binary_representation(value).split('').map.with_index(&method(:apply_mask)).join
    generate_possibilities(binary).map { |posibility| posibility.to_i(2) }.uniq
  end

  private

  def apply_mask(char, idx)
    return mask[idx] if ['1', 'X'].include?(mask[idx])
    char
  end

  def generate_possibilities(binary)
    fill(binary, 0)
  end

  def fill(binary, idx)
    return [binary] if idx >= mask.size
    if binary[idx] == 'X'

      ['0', '1'].map do |replacement|
        working_binary = binary.dup
        working_binary[idx] = replacement
        fill(working_binary, idx + 1)
      end.flatten
    else
      fill(binary, idx + 1)
    end
  end
end
