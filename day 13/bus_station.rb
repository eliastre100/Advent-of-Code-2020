class BusStation
  attr_reader :current_timestamp
  attr_reader :buses

  def initialize(current_timestamp)
    @current_timestamp = current_timestamp
    @buses = []
  end

  def add_bus(bus)
    @buses << bus
  end

  def next_departing_bus
    buses.min_by { |bus| bus.next_departure(current_timestamp) }
  end
end
