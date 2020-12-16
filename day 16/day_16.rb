#!/usr/bin/env ruby

require_relative 'ticket_scanner'

if ARGV.empty?
  warn 'Usage: ./day_16.rb [input file]'
  exit 1
end

ticket_scanner = TicketScanner.new
part = :rules

File.readlines(ARGV.first).each do |line|
  line.chomp!

  next if line == ''

  if line == 'your ticket:'
    part = :personal_ticket; next
  elsif line == 'nearby tickets:'
    part = :tickets
  else
    case part
      when :rules
        rule_splited = line.split(':')
        ticket_scanner.add_rule rule_splited.first.to_sym, rule_splited.last
      when :personal_ticket
      when :tickets
        ticket_scanner.add_ticket line
      else
    end
  end
end

invalid_tickets = ticket_scanner.invalid_tickets

puts "There is an #{invalid_tickets.map { |ticket| ticket[:invalid_values] }.flatten.sum } ticket scanning error rate"
puts "The invalid tickets are:"
puts invalid_tickets.map { |ticket| ticket[:ticket] }.inspect
