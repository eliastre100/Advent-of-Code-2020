require 'rspec'
require_relative '../../day 15/count_table'

RSpec.describe CountTable do
  let(:subject) { described_class.new('0,3,6') }

  describe '#initialize' do
    it 'sets the first numbers' do
      expect(subject.numbers).to eql [0, 3, 6]
    end
  end

  describe '.turn' do
    it 'add a 0 if the number was not spoken' do
      subject.play_turn

      expect(subject.numbers).to eql [0, 3, 6, 0]
    end

    it 'adds the distance if the number was spoken' do
      subject.play_turn
      subject.play_turn

      expect(subject.numbers).to eql [0, 3, 6, 0, 3]
    end

    it 'increases the turn number' do
      subject.play_turn
      subject.play_turn
      subject.play_turn

      expect(subject.turns).to be 3
    end
  end
end
