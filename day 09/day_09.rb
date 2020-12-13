#!/usr/bin/env ruby

require_relative 'xmas_protocol'

if ARGV.size != 2
  warn 'Usage: ./day_09.rb [input file] [preamble size]'
  exit 1
end

xmas_protocol = XMASProtocol.new(ARGV.last.to_i)

File.readlines(ARGV.first).each do |line|
  xmas_protocol.add_frame line
end

weakness = xmas_protocol.weakness

if weakness[:frame].nil?
  puts "No weakness detected"
else
  puts "Weakness found on frame #{weakness[:frame]}. Cannot have value #{weakness[:value]}"
  breaking_frame = xmas_protocol.break_encryption
  puts "Breaking starts at #{breaking_frame[:breaking_frame_start]} for #{breaking_frame[:breaking_factor]} with smallest #{breaking_frame[:breaking_numbers].min} and biggest #{breaking_frame[:breaking_numbers].max} (sum #{breaking_frame[:breaking_numbers].min + breaking_frame[:breaking_numbers].max})"
  puts "Listing all number"
  puts breaking_frame[:breaking_numbers].join(', ')
end
