#!/usr/bin/env ruby

require_relative 'count_table'

if ARGV.size != 2
  warn 'Usage: ./day_15.rb [input file] [target]'
  exit 1
end

input = File.read(ARGV.first).chomp
target = ARGV[1].to_i

count_table = CountTable.new(input)

puts "Playing the game until the turn #{target}. It might take a while depending on your target"

until count_table.turns == target do
  count_table.play_turn
end

puts "After #{count_table.turns} turns, the last number to have been spoken is #{count_table.last_spoken_number}"
