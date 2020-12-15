class Mask
  attr_reader :mask

  def initialize
    @mask = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  end

  def update_mask(mask)
    return false if mask.size != 36 || mask.split('').detect { |char| !['X', '1', '0'].include?(char) }
    @mask = mask
  end

  def apply(value)
    binary = binary_representation(value).split('').map.with_index(&method(:apply_mask)).join
    binary.to_i(2)
  end

  private

  def apply_mask(char, idx)
    return mask[idx] if ['0', '1'].include?(mask[idx])
    char
  end

  def binary_representation(value)
    value.to_s(2).rjust(36, '0')
  end
end
