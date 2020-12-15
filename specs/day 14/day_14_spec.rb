require 'rspec'
require_relative '../../day 14/mask'
require_relative '../../day 14/address_mask'
require_relative '../../day 14/memory'

RSpec.describe Mask do
  let(:subject) { described_class.new }

  describe '#initialize' do
    it 'has an all X mask' do
      expect(subject.mask).to eql 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    end
  end

  describe '.update_mask' do
    it 'return false if the mask is not valid' do
      expect(subject.update_mask('XXXXX')).to be false
      expect(subject.mask).to eql 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

      expect(subject.update_mask('XXXXXXXXZXXXXXXXXXXXXXXXXXXXXXXXXXXX')).to be false
      expect(subject.mask).to eql 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    end

    it 'updates the mask' do
      subject.update_mask 'XXXXXXXXXXXXXXXXXX1XXX0XXXXXXXXXXXXX'

      expect(subject.mask).to eql 'XXXXXXXXXXXXXXXXXX1XXX0XXXXXXXXXXXXX'
    end
  end

  describe '.apply' do
    it 'applies the mask to the number' do
      subject.update_mask 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X'

      expect(subject.apply(11)).to be 73
    end
  end
end

RSpec.describe AddressMask do
  let(:subject) { described_class.new }

  describe '#initialize' do
    it 'has an all 0 mask' do
      expect(subject.mask).to eql '000000000000000000000000000000000000'
    end
  end

  describe '.apply' do
    it 'returns the list of address' do
      subject.update_mask '000000000000000000000000000000X1001X'

      expect(subject.apply(42)).to eql [26, 27, 58, 59]
    end
  end
end

RSpec.describe Memory do
  let(:subject) { described_class.new(:value) }

  describe '#initialize' do
    it 'initialize the memory' do
      expect(subject.memory).to eql({})
    end

    it 'creats a default mask' do
      expect(subject.mask).not_to be nil
    end

    it 'uses the defined mask application' do
      expect(subject.mask_use).to be :value
    end

    it 'creates the correct mask instance' do
      value_memory = described_class.new(:value)
      address_memory = described_class.new(:address)

      expect(value_memory.mask.class).to be Mask
      expect(address_memory.mask.class).to be AddressMask
    end
  end

  describe '.set_memory' do
    context 'with the value use mask' do
      it 'sets the memory' do
        subject.set_memory(1, 10)

        expect(subject.memory[1]).to be 10
      end

      it 'applies the mask' do
        subject.mask.update_mask 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X'
        subject.set_memory(8, 11)

        expect(subject.memory[8]).to be 73
      end
    end

    context 'with the address use mask' do
      let(:subject) { described_class.new(:address) }

      it 'applies the mask' do
        subject.mask.update_mask '000000000000000000000000000000X1001X'

        subject.set_memory(42, 100)

        expect(subject.memory[26]).to be 100
        expect(subject.memory[27]).to be 100
        expect(subject.memory[58]).to be 100
        expect(subject.memory[59]).to be 100
      end
    end
  end

  describe '.memory_sum' do
    it 'returns the memory\'s sum' do
      subject.set_memory(8, 11)
      subject.set_memory(10, 15)

      expect(subject.memory_sum).to be 26
    end
  end
end
