class ExpenseReportManager
  attr_reader :expenses

  def initialize
    @expenses = []
  end

  def add_expense(expense)
    @expenses << expense
  end

  def extract_summable(target)
    root_expense = expenses.detect do |expense|
      expenses.include?(target - expense)
    end

    return [] if root_expense.nil?

    [root_expense, target - root_expense]
  end
  
  def summable_product(target)
    expenses = extract_summable(target)
    expenses.reduce(:*)
  end
end
