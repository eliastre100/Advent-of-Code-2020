#!/usr/bin/env ruby

require_relative 'room'

if ARGV.empty?
  warn 'Usage: ./day_11.rb [input file]'
  exit 1
end

room = Room.new(File.read(ARGV.first))

while room.update do; end

puts "After #{room.generation} generations, the chaos stabilize with the map"
puts room.visualization
puts "\nThere are #{room.occupied_seats} seats occupied"
