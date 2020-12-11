#!/usr/bin/env ruby

require_relative 'bag'

if ARGV.empty?
  warn 'Usage: ./day_07.rb [input file]'
  exit 1
end

File.readlines(ARGV.first).each do |line|
  Bag.new(line)
end

shiny_bag = Bag::List.get_bag('shiny gold')
shiny_bag_containers = Bag::List.registered_bags.select { |bag| bag.can_contain?(shiny_bag) }

puts "#{shiny_bag_containers.count} bags can contain the Shiny Gold bag: #{shiny_bag_containers.map(&:color).join(', ')}"

nested_bags = shiny_bag.nested_bags
puts "One Shiny bag can contain #{nested_bags.map(&:last).reduce(&:+)} bags: #{nested_bags.map { |color, qty| "#{qty} #{color}" }.join(', ')}"
