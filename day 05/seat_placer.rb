class SeatPlacer
  def initialize(rows, column)
    @rows = rows - 1
    @columns = column - 1
  end

  def place(boarding_pass)
    seat = { rows: { min: 0, max: @rows }, columns: { min: 0, max: @columns } }
    seat = apply_seat_search(boarding_pass, seat)
    { row: seat[:rows][:min], column: seat[:columns][:min], id: seat[:rows][:min] * 8 + seat[:columns][:min] }
  end
  
  private
  
  def apply_seat_search(boarding_pass, seats)
    return seats if boarding_pass == ''
    
    update_rows(seats, boarding_pass[0]) if ['B', 'F'].include?(boarding_pass[0])
    update_columns(seats, boarding_pass[0]) if ['L', 'R'].include?(boarding_pass[0])

    apply_seat_search(boarding_pass[1..-1], seats)
  end

  def update_rows(seats, action)
    step = ((seats[:rows][:max] - seats[:rows][:min]).to_f / 2).round

    case action.to_sym
      when :F
        seats[:rows][:max] -= step
      when :B
        seats[:rows][:min] += step
    end
  end

  def update_columns(seats, action)
    step = ((seats[:columns][:max] - seats[:columns][:min]).to_f / 2).round

    case action.to_sym
      when :L
        seats[:columns][:max] -= step
      when :R
        seats[:columns][:min] += step
    end
  end
end
