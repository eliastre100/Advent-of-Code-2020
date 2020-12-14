#!/usr/bin/env ruby

require_relative 'room'

if ARGV.empty?
  warn 'Usage: ./day_11.rb [input file]'
  exit 1
end

input_room = File.read(ARGV.first)
room = Room.new(input_room)

while room.update do; end

puts "After #{room.generation} generations, the chaos stabilizes with the map"
puts room.visualization
puts "There are #{room.occupied_seats} seats occupied\n\n"

room = Room.new(input_room)

while room.update method: :view do; end

puts "After #{room.generation} generation with the view method, the chaos stabilizes with the map"
puts room.visualization
puts "There are #{room.occupied_seats} seats occupied"
