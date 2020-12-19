#!/usr/bin/env ruby

require_relative 'expression'

if ARGV.empty?
  warn 'Usage: ./day_18.rb [input file] [priority operation]'
  exit 1
end

value = 0

operations_definitions = Expression::OPERATIONS.dup

if operations_definitions.key?(ARGV[1].to_sym)
  operations_definitions[ARGV[1].to_sym][:level] = 1
  puts "Puttin the priority to the + operator"
end

File.readlines(ARGV.first).each do |line|
  value += Expression.new(line, operations_definitions).resolve
end

puts "The total sum of all the operations is #{value}"
