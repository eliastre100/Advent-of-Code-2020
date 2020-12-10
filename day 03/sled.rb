class Sled
  def initialize(map)
    @map = map
  end

  def count_trees(x, y)
    (@map.height / y).times.select do |iteration|
      @map.tree?(x * iteration, y * iteration)
    end.count
  end
end
