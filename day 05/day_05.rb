#!/usr/bin/env ruby

require_relative 'seat_manager'
require_relative 'seat_placer'

if ARGV.empty?
  warn 'Usage: ./day_05.rb [input file]'
  exit 1
end

seat_manager = SeatManager.new(128, 8)
placer = SeatPlacer.new(128, 8)

File.readlines(ARGV.first).each do |line|
  seat_manager.add_seat placer.place(line)
end

latest_used_seat = seat_manager.latest_used_seat

puts "The latest used seat have the id #{latest_used_seat[:id]}, is on row #{latest_used_seat[:row]} and column #{latest_used_seat[:column]}"

puts "Here are the remaining seats"
remaining_seats = seat_manager.remaining_seats
remaining_seats.each do |seat|
  puts "Seat id #{seat[:id]}: row #{seat[:row]} column #{seat[:column]}"
end

remaining_seats_ids = remaining_seats.map { |seat| seat[:id] }
seat = remaining_seats.detect { |seat| !remaining_seats_ids.include?(seat[:id] - 1) && !remaining_seats_ids.include?(seat[:id] + 1) }
puts "Yours is probably the seat #{seat[:id]}, row #{seat[:row]} column #{seat[:column]}"
