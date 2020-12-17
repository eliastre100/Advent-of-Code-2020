#!/usr/bin/env ruby

require_relative 'pocket'

if ARGV.empty?
  warn 'Usage: ./day_17.rb [input file]'
  exit 1
end

pocket = Pocket.new(File.read(ARGV.first).chomp)


6.times { pocket.apply_cycle }

puts "After 6 cycles, #{pocket.active_cubes.count} cubes are still active"
puts 'Their representation is:'
pocket.display

