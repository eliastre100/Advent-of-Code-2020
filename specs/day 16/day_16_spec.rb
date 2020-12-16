require 'rspec'
require_relative '../../day 16/ticket_scanner'

RSpec.describe TicketScanner do
  let(:subject) { described_class.new }

  describe '#initialize' do
    it 'has an empty set of rules' do
      expect(subject.rules).to eql({})
    end

    it 'has no tickets' do
      expect(subject.tickets).to eql([])
    end
  end

  describe '.add_rule' do
    it 'adds the rule' do
      subject.add_rule :class, '1-3 or 5-7'
      expect(subject.rules).to eql({ class: [1, 2, 3, 5, 6, 7]})
    end
  end

  describe '.add_ticket' do
    it 'adds the ticket to the list' do
      subject.add_ticket '7,3,47'
      expect(subject.tickets).to eql [[7, 3, 47]]
    end
  end

  describe '.invalid_tickets' do
    it 'returns the invalid tickets' do
      subject.add_rule :class, '1-3 or 5-7'
      subject.add_rule :row, '6-11 or 33-44'
      subject.add_rule :seat, '13-40 or 45-50'

      subject.add_ticket '7,3,47'
      subject.add_ticket '40,4,50'
      subject.add_ticket '55,2,20'
      subject.add_ticket '38,6,12'

      expect(subject.invalid_tickets).to eql [
        { ticket: [40, 4, 50], invalid_values: [4] },
        { ticket: [55, 2, 20], invalid_values: [55] },
        { ticket: [38, 6, 12], invalid_values: [12] }
      ]
    end
  end

  describe '.rules_ticket_index' do
    it 'finds the correct index' do
      subject.add_rule :class, '1-3 or 5-7'
      subject.add_rule :row, '6-11 or 33-44'
      subject.add_rule :seat, '13-40 or 45-50'

      subject.add_ticket '7,3,47'
      subject.add_ticket '40,4,50'
      subject.add_ticket '55,2,20'
      subject.add_ticket '38,6,12'
      subject.add_ticket '11,12,13'

      expect(subject.rules_ticket_index).to eql({ class: 1, row: 0, seat: 2 })
    end
  end
end
