require 'rspec'
require_relative '../../day 01/expense_report_manager'

RSpec.describe ExpenseReportManager do
  let(:subject) { described_class.new }

  describe '.add_expense' do
    it 'adds the expense' do
      subject.add_expense 10

      expect(subject.expenses).to eql [10]
    end
  end

  describe '.extract_summable' do
    before(:each) do
      subject.add_expense 10
      subject.add_expense 20
      subject.add_expense 42
      subject.add_expense 55
    end

    it 'returns the two expenses' do
      expect(subject.extract_summable(30)).to eql [10, 20]
    end

    it 'returns an empty array if there is no match' do
      expect(subject.extract_summable(31)).to eql []
    end

    it 'returns the first match' do
      subject.add_expense 16
      subject.add_expense 14

      expect(subject.extract_summable(30)).to eql [10, 20]
    end

    it 'returns the three expenses' do
      expect(subject.extract_summable(85, number_of_expenses: 3)).to eql [10, 20, 55]
    end

    it "doesn't return less expenses" do
      expect(subject.extract_summable(30, number_of_expenses: 3)).not_to eql [10, 20]
    end
  end

  describe '.summable_product' do
    before(:each) do
      subject.add_expense 10
      subject.add_expense 20
      subject.add_expense 42
      subject.add_expense 55
    end

    it 'returns the product of the two expenses' do
      expect(subject.summable_product(30)).to eql 200
    end

    it 'returns nil if there is no matching expenses' do
      expect(subject.summable_product(31)).to eql nil
    end

    it 'returns the product of the three expeneses' do
      expect(subject.summable_product(30, number_of_expenses: 3)).to eql 11000
    end
  end
end
