#!/usr/bin/env ruby

require_relative 'passport'
require_relative 'passport_reader'
require_relative 'passport_manager'

if ARGV.empty?
  warn 'Usage: ./day_04.rb [input file]'
  exit 1
end

reader = PassportReader.new
manager = PassportManager.new

File.readlines(ARGV.first).each do |line|
  if line.strip == ''
    manager.add_passport reader.extract_passport
  else
    reader.read(line)
  end
end

manager.add_passport reader.extract_passport

puts "#{manager.valid_passports.count} are still valid"
