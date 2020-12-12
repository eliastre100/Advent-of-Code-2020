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
  puts "Trying to recover ..."
  patch = game_console.recover

  if patch[:status] == :successful
    puts "Patch found ! The patch is an invalid #{patch[:type]} line #{patch[:line]}"
    puts "Applying patch"
    game_console.apply_patch patch
    status = game_console.execute
    puts "New accumulator is #{game_console.accumulator} with status #{status[:status]}"
  else
    puts "No patch found ... Aborting"
  end
end
