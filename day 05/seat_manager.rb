class SeatManager
  attr_reader :seats

  def initialize(rows = 0, columns = 0)
    @seats = []
    @rows = rows
    @columns = columns
  end

  def add_seat(seat)
    @seats << seat
  end

  def latest_used_seat
    seats.max_by do |seat|
      seat[:id]
    end
  end

  def remaining_seats
    used_seats_ids = seats.map { |seat| seat[:id] }
    missing_seats_ids = (0..(@rows * @columns - 1)).reject { |seat| used_seats_ids.include?(seat) }
    missing_seats_ids.map { |seat_id| { row: seat_id / @columns, column: seat_id % @columns, id: seat_id } }
  end
end
