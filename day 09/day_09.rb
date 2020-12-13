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
end
