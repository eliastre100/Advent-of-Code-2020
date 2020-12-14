class Ship

  DIRECTIONS = [:north, :east, :south, :west]
  ACTIONS = { N: :north, E: :east, S: :south, W: :west, L: :left, R: :right, F: :forward }

  attr_reader :direction
  attr_reader :position
  attr_reader :cap

  def initialize(direction = :east)
    @direction = direction
    @cap = 90
    @position = { x: 0, y: 0 }
  end

  def north(value)
    position[:y] += value
  end

  def south(value)
    position[:y] -= value
  end

  def east(value)
    position[:x] += value
  end

  def west(value)
    position[:x] -= value
  end

  def left(degrees)
    @cap = (@cap - degrees) % 360
    @direction = current_cap_direction
  end

  def right(degrees)
    @cap = (@cap + degrees) % 360
    @direction = current_cap_direction
  end

  def forward(value)
    public_send(direction, value)
  end

  def manhattan_distance
    position[:x].abs + position[:y].abs
  end

  def handle(instruction)
    action = instruction[0]
    value = instruction[1..-1]

    public_send(ACTIONS[action.to_sym], value.to_i)
  end

  private

  def current_cap_direction
    case cap
      when (0..45)
        :north
      when (45..135)
        :east
      when (135..225)
        :south
      when (225..315)
        :west
      else # more than 315 is back to north up to 360 which start a new cycle
        :north
    end
  end
end
