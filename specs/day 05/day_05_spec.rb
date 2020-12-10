require 'rspec'
require_relative '../../day 05/seat_placer'
require_relative '../../day 05/seat_manager'

RSpec.describe SeatPlacer do
  let(:subject) { described_class.new(128, 8) }

  describe '.place' do
    it 'finds the correct row' do
      expect(subject.place('FBFBBFFRLR')[:row]).to eql 44
      expect(subject.place('BFFFBBFRRR')[:row]).to eql 70
      expect(subject.place('FFFBBBFRRR')[:row]).to eql 14
      expect(subject.place('BBFFBBFRLL')[:row]).to eql 102
    end

    it 'finds the correct column' do
      expect(subject.place('FBFBBFFRLR')[:column]).to eql 5
      expect(subject.place('BFFFBBFRRR')[:column]).to eql 7
      expect(subject.place('FFFBBBFRRR')[:column]).to eql 7
      expect(subject.place('BBFFBBFRLL')[:column]).to eql 4
    end

    it 'finds the correct id' do
      expect(subject.place('FBFBBFFRLR')[:id]).to eql 357
      expect(subject.place('BFFFBBFRRR')[:id]).to eql 567
      expect(subject.place('FFFBBBFRRR')[:id]).to eql 119
      expect(subject.place('BBFFBBFRLL')[:id]).to eql 820
    end
  end
end

RSpec.describe SeatManager do
  let(:subject) { described_class.new }

  describe '.add_seat' do
    it 'adds the seat' do
      subject.add_seat({ row: 10, column: 5, id: 42 })

      expect(subject.seats).to include({ row: 10, column: 5, id: 42 })
    end
  end

  describe '.latest_used_seat' do
    it 'returns the latest used seat' do
      subject.add_seat({ row: 10, column: 5, id: 85 })
      subject.add_seat({ row: 20, column: 5, id: 165 })
      subject.add_seat({ row: 15, column: 5, id: 125 })

      expect(subject.latest_used_seat).to eql({ row: 20, column: 5, id: 165 })
    end
  end

  describe '.remaining seats' do
    let(:subject) { described_class.new(2, 2) }

    it 'returns all the missing seats' do
      subject.add_seat({ row: 0, column: 0, id: 0 })
      subject.add_seat({ row: 0, column: 1, id: 1 })
      subject.add_seat({ row: 1, column: 0, id: 2 })

      expect(subject.remaining_seats).to eql [{ row: 1, column: 1, id: 3}]
    end
  end
end
