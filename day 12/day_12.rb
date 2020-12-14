#!/usr/bin/env ruby

require_relative 'ship'
require_relative 'fixed_ship'

if ARGV.empty?
  warn 'Usage: ./day_12.rb [input file]'
  exit 1
end

ship = Ship.new
fixed_ship = FixedShip.new

File.readlines(ARGV.first).each do |line|
  ship.handle line
  fixed_ship.handle line
end

puts "The normal ship is now at a manhattan distance of #{ship.manhattan_distance}"
puts "The fixed ship is now at a manhattan distance of #{fixed_ship.manhattan_distance}"
