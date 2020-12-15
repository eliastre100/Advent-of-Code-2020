#!/usr/bin/env ruby

require_relative 'bus'
require_relative 'bus_station'

if ARGV.empty?
  warn 'Usage: ./day_13.rb [input file] [minimum chained time]'
  exit 1
end

input = File.read(ARGV.first).split("\n")

bus_station = BusStation.new(input.first.to_i)

input.last.split(',').each do |bus_line|
  if bus_line == 'x'
    bus_station.increase_index
  else
    bus_station.add_bus Bus.new(bus_line.to_i)
  end
end

next_bus = bus_station.next_departing_bus
wait_needed = next_bus.next_departure(bus_station.current_timestamp) - bus_station.current_timestamp

puts "With the current time at #{bus_station.current_timestamp}, the next bus to depart from the bus station is the bus #{next_bus.trip_duration} at #{next_bus.next_departure(bus_station.current_timestamp)} (in #{wait_needed} minutes)"
puts "The id of the trip (the bus id times the departure timestamp) is #{wait_needed * next_bus.trip_duration}"

puts "The first chained departure is at #{bus_station.next_chained_departure(ARGV[1].to_i || 0)}"
