#!/usr/bin/env ruby

require_relative 'group'
require_relative 'group_manager'

if ARGV.empty?
  warn 'Usage: ./day_06.rb [input file]'
  exit 1
end

group_manager = GroupManager.new

File.readlines(ARGV.first).each do |line|
  group_manager.add_answers line
end

puts "There are #{group_manager.groups.count} with #{group_manager.groups.map(&:unique_answers).map(&:count).reduce(&:+)} answers in total"
puts "#{group_manager.groups.map(&:unanimous_answers).map(&:count).reduce(&:+)} answers are unanimous"
