class Sled
  attr_reader :routes

  def initialize(map)
    @map = map
    @routes = []
  end

  def count_trees(x, y)
    (@map.height.to_f / y).round.times.select do |iteration|
      @map.tree?(x * iteration, y * iteration)
    end.count
  end

  def add_route(x, y)
    @routes << { x: x, y: y }
  end

  def compute_routes
    best_route = { x: nil, y: nil, trees: nil }
    product = 1

    routes.each do |route|
      trees = count_trees(route[:x], route[:y])
      product *= trees
      best_route = { x: route[:x], y: route[:y], trees: trees } if best_route[:trees].nil? || trees < best_route[:trees]
    end

    {
      best_route: best_route,
      product: product
    }
  end
end
