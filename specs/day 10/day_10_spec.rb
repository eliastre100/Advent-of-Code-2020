require 'rspec'
require_relative '../../day 10/adapter'
require_relative '../../day 10/adapter_bag'

RSpec.describe Adapter do
  let(:subject) { described_class.new(10) }

  describe '#initialize' do
    it 'sets the joltage' do
      expect(subject.joltage).to be 10
    end
  end
end

RSpec.describe AdapterBag do
  let(:subject) { described_class.new }

  describe '.add_adapter' do
    it 'adds the adapter to the list' do
      adapter = Adapter.new(10)
      subject.add_adapter(adapter)

      expect(subject.adapters).to include adapter
    end

    it 'sorts the adapters' do
      adapter_low = Adapter.new(7)
      adapter_medium = Adapter.new(10)
      adapter_high = Adapter.new(13)

      subject.add_adapter(adapter_medium)
      subject.add_adapter(adapter_high)
      subject.add_adapter(adapter_low)

      expect(subject.adapters).to eql [adapter_low, adapter_medium, adapter_high]
    end
  end

  describe '.applied_tension_differences' do
    it 'returns the correct tension difference' do
      adapter_low = Adapter.new(3)
      adapter_medium = Adapter.new(5)
      adapter_high = Adapter.new(6)
      adapter_very_high = Adapter.new(9)

      subject.add_adapter(adapter_medium)
      subject.add_adapter(adapter_high)
      subject.add_adapter(adapter_low)
      subject.add_adapter(adapter_very_high)

      expect(subject.applied_tension_differences).to eql({ '1': 1, '2': 1, '3': 2 })
    end
  end

  describe '.count_possible_arrangements' do
    it 'finds the correct number of arrangements' do
      [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4].each { |joltage| subject.add_adapter Adapter.new(joltage) }

      expect(subject.count_possible_arrangements).to be 8
    end
  end
end
