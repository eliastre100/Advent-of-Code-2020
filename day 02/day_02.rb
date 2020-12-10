#!/usr/bin/env ruby

require_relative 'password_manager'

if ARGV.empty?
  warn 'Usage: ./day_02.rb [input file] [SledRental | OfficialTobogganCorporate]'
  exit 1
end

rule_class = ARGV[1] == "OfficialTobogganCorporate" ? PasswordManager::OfficialTobogganCorporatePolicyRule : PasswordManager::SledRentalRule

password_manager = PasswordManager.new(rule_class)

File.readlines(ARGV.first).each do |line|
  row = line.split(':').map(&:strip)
  password_manager.add_password(row[1], row[0])
end

puts "#{password_manager.valid_passwords.size} are still valid"
