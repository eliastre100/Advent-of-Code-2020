class Room
  attr_reader :positions
  attr_reader :generation

  FLOOR_CELL = '.'
  EMPTY_SEAT_CELL = 'L'
  OCCUPIED_SEAT_CELL = '#'


  def initialize(room_schema)
    @positions = room_schema.split("\n").map(&:strip).map { |row| row.split('')}
    @generation = 0
  end

  def height
    positions.size
  end

  def width
    positions[0].size
  end

  def update(method: :direct)
    new_positions = generate_new_positions(method)
    return false if visualization(new_positions).eql?(visualization)


    @generation += 1
    @positions = new_positions
  end

  def visualization(map_data = nil)
    (map_data || positions).map { |row| row.join('') }.join("\n")
  end

  def occupied_seats
    positions.map do |row|
      (row.group_by(&:itself)[OCCUPIED_SEAT_CELL] || []).count
    end.sum
  end

  private

  def generate_new_positions(method)
    cell_generation_method = method == :direct ? method(:new_cell_at_direct) : method(:new_cell_at_view)

    positions.map.with_index do |row, row_id|
      row.map.with_index do |cell, cell_id|
        cell_generation_method.call(cell, cell_id, row_id)
      end
    end
  end

  def occupied_direct_neighbour(x, y)
    target_seats = (-1..1).map do |row_idx|
      (-1..1).map do |cell_idx|
        { x: x + cell_idx, y: y + row_idx } unless row_idx == 0 && cell_idx == 0
      end
    end.flatten.compact

    target_seats.select { |position| occupied_direct?(position[:x], position[:y]) }.count
  end

  def occupied_view_neighbour(x, y)
    target_seats_vectors = (-1..1).map do |row_idx|
      (-1..1).map do |cell_idx|
        { x: cell_idx, y: row_idx } unless (row_idx == 0 && cell_idx == 0) || out_of_bound?(x + cell_idx, y + row_idx)
      end
    end.flatten.compact

    target_seats_vectors.select { |vector| first_seat_in_direction(x, y, vector) == OCCUPIED_SEAT_CELL }.count
  end

  def first_seat_in_direction(x, y, vector)
    next_x_position = x + vector[:x]
    next_y_position = y + vector[:y]

    return positions[y][x] if out_of_bound?(next_x_position, next_y_position)

    next_seat_type = positions[next_y_position][next_x_position]
    return next_seat_type if [OCCUPIED_SEAT_CELL, EMPTY_SEAT_CELL].include?(next_seat_type)

    first_seat_in_direction(next_x_position, next_y_position, vector)
  end

  def out_of_bound?(x, y)
    (x.negative? || x >= width || y.negative? || y >= height)
  end

  def occupied_direct?(x, y)
    return false if out_of_bound?(x, y)
    positions[y][x] == OCCUPIED_SEAT_CELL
  end

  def new_cell_at_direct(cell, x, y)
    return OCCUPIED_SEAT_CELL if cell == EMPTY_SEAT_CELL && occupied_direct_neighbour(x, y) == 0
    return EMPTY_SEAT_CELL if cell == OCCUPIED_SEAT_CELL && occupied_direct_neighbour(x, y) >= 4
    cell
  end

  def new_cell_at_view(cell, x, y)
    return FLOOR_CELL if cell == FLOOR_CELL
    return OCCUPIED_SEAT_CELL if cell == EMPTY_SEAT_CELL && occupied_view_neighbour(x, y) == 0
    return EMPTY_SEAT_CELL if cell == OCCUPIED_SEAT_CELL && occupied_view_neighbour(x, y) >= 5
    cell
  end
end
