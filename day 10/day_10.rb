#!/usr/bin/env ruby

require_relative 'adapter'
require_relative 'adapter_bag'

if ARGV.empty?
  warn 'Usage: ./day_10.rb [input file]'
  exit 1
end

adapter_bag = AdapterBag.new

File.readlines(ARGV.first).each do |line|
  adapter_bag.add_adapter Adapter.new(line.chomp.to_i)
end

tensions_differences = adapter_bag.applied_tension_differences
tensions_differences[:'3'] = (tensions_differences[:'3'] || 0) + 1

puts "There is #{adapter_bag.adapters.count} adapters in the bag."
puts "There are #{tensions_differences.map { |difference, count| "#{count} adapters with a #{difference} difference" }.join(', ')}"
puts "The product of 1 and 3 differences is #{tensions_differences[:'1'] * tensions_differences[:'3']}"
puts "There are #{adapter_bag.count_possible_arrangements} possible arrangements to connect the outlet to the device"
