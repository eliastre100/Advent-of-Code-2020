require_relative 'ship'

class FixedShip < Ship
  attr_reader :waypoint

  def initialize(waypoint_x = 10, waypoint_y = 1)
    @waypoint = { x: waypoint_x, y: waypoint_y }
    @position = { x: 0, y: 0 }
  end

  def north(value)
    waypoint[:y] += value
  end

  def east(value)
    waypoint[:x] += value
  end

  def south(value)
    waypoint[:y] -= value
  end

  def west(value)
    waypoint[:x] -= value
  end

  def left(value)
    rotate(value)
  end

  def right(value)
    rotate(-value)
  end

  def forward(value)
    position[:x] += waypoint[:x] * value
    position[:y] += waypoint[:y] * value
  end

  private

  def rotate(angle)
    radiant = angle * (Math::PI / 180)
    sin = Math.sin(radiant)
    cos = Math.cos(radiant)

    new_x = waypoint[:x] * cos - waypoint[:y] * sin
    new_y = waypoint[:x] * sin + waypoint[:y] * cos

    @waypoint = { x: new_x.round, y: new_y.round }
  end
end
