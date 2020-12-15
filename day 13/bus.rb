class Bus
  attr_reader :trip_duration

  def initialize(trip_duration)
    @trip_duration = trip_duration
  end

  def next_departure(from)
    from + (trip_duration - (from % trip_duration))
  end

  def have_departure_at?(time)
    (time % trip_duration).zero?
  end
end
