class CountTable
  attr_reader :numbers

  def initialize(numbers = '')
    @numbers = numbers.split(',').map(&:to_i)
  end

  def play_turn
    @numbers << (have_been_spoken?(numbers.last) ? time_since_spoken(numbers.last) : 0)
  end

  def turns
    @numbers.size
  end

  private

  def have_been_spoken?(number)
    numbers[0..-2].include?(number)
  end

  def time_since_spoken(number)
    numbers.size - numbers[0..-2].rindex(number) - 1 # the last number is not in the number of turn the numbers are apart
  end
end
