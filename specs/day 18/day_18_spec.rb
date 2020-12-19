require 'rspec'
require_relative '../../day 18/expression'

require 'awesome_print'
RSpec.describe Expression do
  let(:subject) { described_class.new('2 + (5 * 10)') }

  describe '#initialize' do
    context 'for a single number' do
      it 'sets the correct operation and operands' do
        subject = described_class.new('147')

        expect(subject.operation).to be :number
        expect(subject.first_operand).to be 147
        expect(subject.second_operand).to be nil
      end
    end

    context 'for a single operation' do
      it 'sets the correct multiply operation operands and operations' do
        subject = described_class.new('2 * 10')

        expect(subject.first_operand).to eql Expression.new('2')
        expect(subject.second_operand).to eql Expression.new('10')
        expect(subject.operation).to be :multiplication
      end

      it 'sets the correct addition operation operands and operation' do
        subject = described_class.new('2 + 10')

        expect(subject.first_operand).to eql Expression.new('2')
        expect(subject.second_operand).to eql Expression.new('10')
        expect(subject.operation).to be :addition
      end
    end

    context 'for multiple operations' do
      it 'sets the correct order of operations' do
        subject = described_class.new('1 * 10 + 15')

        expect(subject.first_operand).to eql Expression.new('1 * 10')
        expect(subject.second_operand).to eql Expression.new('15')
        expect(subject.operation).to be :addition
      end
    end

    context 'with parenthesis' do
      it 'sets the priority accordingly' do
        subject = described_class.new('10 + (5 * 10)')

        expect(subject.first_operand).to eql Expression.new('10')
        expect(subject.second_operand).to eql Expression.new('5 * 10')
        expect(subject.operation).to be :addition
      end
    end

    context 'with multiple parenthesis' do
      it 'sets the priorities accordingly' do
        subject = described_class.new('(10 * (5 + 2)) + 10')

        expect(subject.first_operand).to eql Expression.new('10 * (5 + 2)')
        expect(subject.second_operand).to eql Expression.new('10')
        expect(subject.operation).to be :addition
      end
    end
  end

  describe '.resolve' do
    it 'returns the correct response' do
      expect(subject.resolve).to be 52
    end

    it 'returns the correction response' do
      expect(described_class.new('5 + (8 * 3 + 9 + 3 * 4 * 3)').resolve).to be 437
    end

    it 'returns the correct response' do
      expect(described_class.new('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))').resolve).to be 12240
    end

    it 'returns the correct response' do
      expect(described_class.new('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2').resolve).to be 13632
    end
  end
end
