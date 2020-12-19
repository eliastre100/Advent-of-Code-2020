#!/usr/bin/env ruby

require_relative 'expression'

if ARGV.empty?
  warn 'Usage: ./day_18.rb [input file]'
  exit 1
end

value = 0

File.readlines(ARGV.first).each do |line|
  value += Expression.new(line).resolve
end

puts "The total sum of all the operations is #{value}"
