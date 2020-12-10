#!/usr/bin/env ruby

require_relative 'expense_report_manager'

if ARGV.empty?
  warn 'Usage: ./day_01.rb [input file]'
  exit 1
end

manager = ExpenseReportManager.new

File.readlines(ARGV.first).each do |line|
  manager.add_expense(line.to_i)
end

puts "Your expense product is: #{manager.summable_product(2020)}"
