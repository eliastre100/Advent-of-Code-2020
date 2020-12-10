#!/usr/bin/env ruby

require_relative 'expense_report_manager'

if ARGV.empty?
  warn 'Usage: ./day_01.rb [input file] [number of expenses]'
  exit 1
end

manager = ExpenseReportManager.new

File.readlines(ARGV.first).each do |line|
  manager.add_expense(line.to_i)
end

number_of_expenses = ARGV[1].nil? ? 2 : ARGV[1].to_i

puts "Your expense product for #{number_of_expenses} expenses is: #{manager.summable_product(2020, number_of_expenses: number_of_expenses)}"
