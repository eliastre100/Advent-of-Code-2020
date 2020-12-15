class BusStation
  attr_reader :current_timestamp
  attr_reader :buses

  def initialize(current_timestamp)
    @current_timestamp = current_timestamp
    @buses = []
    @buses_index = 0
  end

  def add_bus(bus)
    @buses << { bus: bus, index: @buses_index }
    increase_index
  end

  def increase_index
    @buses_index += 1
  end

  def next_departing_bus
    buses.min_by { |bus| bus[:bus].next_departure(current_timestamp) }[:bus]
  end

  def next_chained_departure(from)
    return from if chained_departure?(from)
    synchronizes_at(buses.first[:bus].next_departure(from), 0)
  end

  def synchronizes_at(from, number_of_bus_synchronized)
    return from if chained_departure?(from)

    step = (0..number_of_bus_synchronized).map { |bus_idx| buses[bus_idx][:bus].trip_duration }.inject(:*)
    buses_to_synchronize = buses[0, (number_of_bus_synchronized + 2)]

    until synchronized?(from, buses_to_synchronize)
      from += step
    end
    synchronizes_at(from, number_of_bus_synchronized + 1)
  end

  private

  def synchronized?(from, buses_list)
    buses_list.detect { |bus| !bus[:bus].have_departure_at?(from + bus[:index]) }.nil?
  end

  def chained_departure?(from)
    buses.detect { |bus| !bus[:bus].have_departure_at?(from + bus[:index]) }.nil?
  end
end
