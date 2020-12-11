require 'rspec'
require_relative '../../day 07/bag'

RSpec.describe Bag do
  before(:each) do
    Bag::List.instance_variable_set(:'@registered_bags', nil)
  end

  describe '#initialze' do
    it 'sets the correct bag name' do
      subject = described_class.new('light red bags contain 1 bright white bag, 2 muted yellow bags.')

      expect(subject.color).to eql 'light red'
    end

    it 'sets the correct containable bag names' do
      subject = described_class.new('light red bags contain 1 bright white bag, 2 muted yellow bags.')

      expect(subject.containable).to eql({ 'bright white' => 1, 'muted yellow' => 2})
    end

    it 'adds itself to the list of bags type' do
      subject = described_class.new('light red bags contain 1 bright white bag, 2 muted yellow bags.')

      expect(Bag::List.registered_bags).to include subject
    end

    it 'does not keep the no other bags color' do
      subject = described_class.new('dark violet bags contain no other bags.')

      expect(subject.containable).to eql({})
    end
  end

  describe 'can_contain?' do
    let(:subject) { described_class.new('light red bags contain 1 bright white bag, 2 muted yellow bags.') }

    it 'returns true if it can contain the bag' do
      other_bag = described_class.new('muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.')

      expect(subject.can_contain?(other_bag)).to be true
    end

    it 'returns false if it cannot contain the bag' do
      other_bag = described_class.new('shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.aca')

      expect(subject.can_contain?(other_bag)).to be false
    end

    it 'returns true for an indirect holding' do
      described_class.new('muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.')
      bag = described_class.new('faded blue bags contain no other bags.')

      expect(subject.can_contain?(bag)).to be true
    end
  end

  describe '.nested_bags' do
    it 'returns the nested bags' do
      subject = described_class.new('light red bags contain 1 bright white bag, 2 muted yellow bags.')
      described_class.new('muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.')
      described_class.new('faded blue bags contain no other bags.')

      expect(subject.nested_bags).to eql({ 'bright white' => 1, 'muted yellow' => 2, 'shiny gold' => 4, 'faded blue' => 18 })
    end
  end
end

RSpec.describe Bag::List do
  describe '#get_bag' do
    it 'returns the correct bag' do
      Bag.new('vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.')
      target = Bag.new('dotted black bags contain no other bags.')

      expect(described_class.get_bag('dotted black')).to be target
    end

    it 'returns nil if the bag does not exist' do
      expect(described_class.get_bag('unknown bag')).to eql nil
    end
  end
end
