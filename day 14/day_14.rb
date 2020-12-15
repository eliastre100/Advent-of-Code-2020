#!/usr/bin/env ruby

require_relative 'memory'

if ARGV.empty?
  warn 'Usage: ./day_14.rb [input file]'
  exit 1
end

memory = Memory.new

File.readlines(ARGV.first).each do |line|
  if line.start_with?('mask = ')
    mask = line.match(/mask = ([X01]*)/)[1]
    memory.mask.update_mask(mask).inspect
  else
    action_match = line.match(/mem\[([0-9]*)\] = ([0-9]*)$/)
    memory.set_memory(action_match[1].to_i, action_match[2].to_i)
  end
end

puts "The memory contain #{memory.memory_sum} in memory"
