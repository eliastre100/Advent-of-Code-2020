#!/usr/bin/env ruby

require_relative 'bus'
require_relative 'bus_station'

if ARGV.empty?
  warn 'Usage: ./day_13.rb [input file]'
  exit 1
end

input = File.read(ARGV.first).split("\n")

bus_station = BusStation.new(input.first.to_i)

input.last.split(',').each do |bus_line|
  bus_station.add_bus Bus.new(bus_line.to_i) unless bus_line == 'x'
end

next_bus = bus_station.next_departing_bus
wait_needed = next_bus.next_departure(bus_station.current_timestamp) - bus_station.current_timestamp

puts "With the current time at #{bus_station.current_timestamp}, the next bus to depart from the bus station is the bus #{next_bus.trip_duration} at #{next_bus.next_departure(bus_station.current_timestamp)} (in #{wait_needed} minutes)"
puts "The id of the trip (the bus id times the departure timestamp) is #{wait_needed * next_bus.trip_duration}"
