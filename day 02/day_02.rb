#!/usr/bin/env ruby

require_relative 'password_manager'

if ARGV.empty?
  warn 'Usage: ./day_01.rb [input file]'
  exit 1
end

password_manager = PasswordManager.new

File.readlines(ARGV.first).each do |line|
  row = line.split(':').map(&:strip)
  password_manager.add_password(row[1], row[0])
end

puts "#{password_manager.valid_passwords.size} are still valid"
