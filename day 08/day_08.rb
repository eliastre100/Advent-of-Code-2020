#!/usr/bin/env ruby

require_relative 'game_console'

if ARGV.empty?
  warn 'Usage: ./day_08.rb [input file]'
  exit 1
end

game_console = GameConsole.new(File.read(ARGV.first))

status = game_console.execute

if status[:error].nil?
  puts "Everything went fine ! The game console ran smoothly"
else
  puts "The game console ran into the error: #{status[:error]} on line #{status[:line]}. The accumulator had the value #{game_console.accumulator}"
end
