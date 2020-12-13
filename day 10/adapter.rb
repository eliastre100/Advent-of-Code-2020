class Adapter
  attr_reader :joltage

  def initialize(joltage)
    @joltage = joltage
  end

  def can_plug?(adapter)
    adapter.joltage <= joltage && adapter.joltage >= (joltage - 3)
  end
end
