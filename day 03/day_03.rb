#!/usr/bin/env ruby

require_relative 'map'
require_relative 'sled'

if ARGV.size < 3
  warn 'Usage: ./day_03.rb [input file] ([x] [y] ...)'
  exit 1
end

map = Map.new(File.read(ARGV.first))
sled = Sled.new(map)

ARGV[1..-1].each_slice(2) do |x, y|
  sled.add_route(x.to_i, y.to_i)
end

routes_output = sled.compute_routes

puts "The best route is #{routes_output[:best_route][:x]} right #{routes_output[:best_route][:y]} down with #{routes_output[:best_route][:trees]} trees"
puts "The total product of all the routes is #{routes_output[:product]}"
