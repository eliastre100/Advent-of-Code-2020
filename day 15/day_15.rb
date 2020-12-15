#!/usr/bin/env ruby

require_relative 'count_table'

if ARGV.empty?
  warn 'Usage: ./day_15.rb [input file]'
  exit 1
end

input = File.read(ARGV.first).chomp

count_table = CountTable.new(input)

count_table.play_turn until count_table.turns == 2020

puts "After #{count_table.turns} turns, the last number to have been spoken is #{count_table.numbers.last}"
