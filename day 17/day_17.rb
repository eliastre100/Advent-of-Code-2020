#!/usr/bin/env ruby

require_relative 'pocket'

if ARGV.size != 2
  warn 'Usage: ./day_17.rb [input file] [use W ? true / false]'
  exit 1
end

use_w = ARGV[1].downcase == 'true'
pocket = Pocket.new(File.read(ARGV.first).chomp, use_w: use_w)

6.times { pocket.apply_cycle }

puts use_w ? 'With the W axis' : 'Without the W axis'
puts "After 6 cycles, #{pocket.active_cubes.count} cubes are still active"

if use_w
  puts 'Not printing their representation as it is probably too large'
else
  puts 'Their representation is:'
  pocket.display
end
