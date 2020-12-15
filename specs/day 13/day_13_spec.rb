require 'rspec'
require_relative '../../day 13/bus'
require_relative '../../day 13/bus_station'

RSpec.describe Bus do
  let(:subject) { described_class.new(10) }

  describe "#initialize" do
    it 'sets the correct trip duration' do
      expect(subject.trip_duration).to be 10
    end
  end

  describe '.next_departure' do
    it 'returns the next departure timestamp' do
      expect(subject.next_departure(101)).to be 110
    end
  end

  describe '.have_departure_at?' do
    it 'returns false if there are no departure' do
      expect(subject.have_departure_at?(21)).to be false
    end

    it 'returns true if there are a departure' do
      expect(subject.have_departure_at?(20)).to be true
    end
  end
end

RSpec.describe BusStation do
  let(:subject) { described_class.new(101) }

  describe '#initialize' do
    it 'sets the current timestamp' do
      expect(subject.current_timestamp).to be 101
    end
  end

  describe '.add_bus' do
    it 'adds the bus to the bus lines' do
      bus = Bus.new(10)

      expect(subject.buses).to eql []
      subject.add_bus bus

      expect(subject.buses).to eql [{ bus: bus, index: 0 }]
    end
  end

  describe '.next_departing_bus' do
    it 'returns the next departing bus' do
      bus = Bus.new(6)

      subject.add_bus Bus.new(10)
      subject.add_bus bus
      subject.add_bus Bus.new(5)

      expect(subject.next_departing_bus).to be bus
    end
  end

  describe '.next_chained_departure' do
    it 'finds the next chain of departure' do
      [7, 13, 'x', 'x', 59, 'x', 31, 19 ].each do |bus_line|
        if bus_line == 'x'
          subject.increase_index
        else
          subject.add_bus Bus.new(bus_line)
        end
      end

      expect(subject.next_chained_departure(0)).to be 1068781
    end
  end
end
