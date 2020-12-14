#!/usr/bin/env ruby

require_relative 'ship'

if ARGV.empty?
  warn 'Usage: ./day_12.rb [input file]'
  exit 1
end

ship = Ship.new

File.readlines(ARGV.first).each do |line|
  ship.handle line
end

puts "The ship is now at a manhattan distance of #{ship.manhattan_distance}"
