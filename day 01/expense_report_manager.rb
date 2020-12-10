class ExpenseReportManager
  attr_reader :expenses

  def initialize
    @expenses = []
  end

  def add_expense(expense)
    @expenses << expense
  end

  def extract_summable(target, number_of_expenses: 2)
    return [] if number_of_expenses.zero?

    additional_expenses = []

    root_expense = expenses.detect do |expense|
      additional_expenses = extract_summable(target - expense, number_of_expenses: number_of_expenses - 1).to_a
      additional_expenses.size == (number_of_expenses - 1) && (additional_expenses.reduce(&:+).to_i + expense) == target
    end

    return [] if root_expense.nil?

    [root_expense] + additional_expenses
  end
  
  def summable_product(target, number_of_expenses: 2)
    expenses = extract_summable(target, number_of_expenses: number_of_expenses)
    expenses.reduce(:*)
  end
end
