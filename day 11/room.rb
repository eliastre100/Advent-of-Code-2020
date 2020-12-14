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

  def update
    new_positions = generate_new_positions
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

  def generate_new_positions
    positions.map.with_index do |row, row_id|
      row.map.with_index do |cell, cell_id|
        new_cell_at(cell, cell_id, row_id)
      end
    end
  end

  def occupied_neighbour(x, y)
    target_seats = (-1..1).map do |row_idx|
      (-1..1).map do |cell_idx|
        { x: x + cell_idx, y: y + row_idx } unless row_idx == 0 && cell_idx == 0
      end
    end.flatten.compact

    target_seats.select { |position| occupied?(position[:x], position[:y]) }.count
  end

  def occupied?(x, y)
    return false if (x.negative? || x >= width || y.negative? || y >= height)
    positions[y][x] == OCCUPIED_SEAT_CELL
  end

  def new_cell_at(cell, x, y)
    return OCCUPIED_SEAT_CELL if cell == EMPTY_SEAT_CELL && occupied_neighbour(x, y) == 0
    return EMPTY_SEAT_CELL if cell == OCCUPIED_SEAT_CELL && occupied_neighbour(x, y) >= 4
    cell
  end
end
