class CountTable
  attr_reader :turns
  attr_reader :last_spoken_number

  def initialize(numbers = '')
    @numbers = {}
    @turns = 0
    numbers.split(',').map(&:to_i).each(&method(:add_number))
  end

  def play_turn
    number = (have_been_spoken?(last_spoken_number) ? time_since_spoken(last_spoken_number) : 0)
    add_number number
  end

  private

  def add_number(number)
    @numbers[number] = [(@numbers[number] || []).last, turns].compact
    @last_spoken_number = number
    @turns += 1
  end

  def have_been_spoken?(number)
    @numbers.has_key?(number) && @numbers[number].size == 2
  end

  def time_since_spoken(number)
    turns - @numbers[number].first - 1
  end
end
