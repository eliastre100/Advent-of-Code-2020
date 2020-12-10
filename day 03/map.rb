class Map
  def initialize(map)
    @map = map.split("\n")
  end

  def height
    @map.size
  end

  def width
    @map.first.size
  end

  def tree?(x, y)
    @map[y % height][x % width] == '#'
  end
end
