require 'rspec'
require_relative '../../day 15/count_table'

RSpec.describe CountTable do
  let(:subject) { described_class.new('0,3,6') }

  describe '#initialize' do
    it 'sets the last_spoken_number' do
      expect(subject.last_spoken_number).to be 6
    end
  end

  describe '.turn' do
    it 'add a 0 if the number was not spoken' do
      subject.play_turn

      expect(subject.last_spoken_number).to be 0
    end

    it 'adds the distance if the number was spoken' do
      subject.play_turn
      subject.play_turn

      expect(subject.last_spoken_number).to be 3
    end

    it 'increases the turn number' do
      subject.play_turn
      subject.play_turn
      subject.play_turn

      expect(subject.turns).to be 6
    end
  end
end
