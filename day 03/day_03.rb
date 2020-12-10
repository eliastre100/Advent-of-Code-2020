#!/usr/bin/env ruby

require_relative 'map'
require_relative 'sled'

if ARGV.size != 3
  warn 'Usage: ./day_03.rb [input file] [x] [y]'
  exit 1
end

x = ARGV[1].to_i
y = ARGV[2].to_i

map = Map.new(File.read(ARGV.first))
sled = Sled.new(map)

puts "With a slope of #{x} right for #{y} down you would encounter #{sled.count_trees(x, y)} trees"
