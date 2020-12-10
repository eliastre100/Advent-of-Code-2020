require 'rspec'
require_relative '../../day 03/map'
require_relative '../../day 03/sled'

RSpec.describe Map do
  let(:map) { <<~EOM
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
  EOM
  }
  let(:subject) { Map.new(map) }

  describe '.height' do
    it 'has the correct number of height' do
      expect(subject.height).to eql 11
    end
  end

  describe '.width' do
    it 'has the correct number of width' do
      expect(subject.width).to eql 11
    end
  end

  describe '.is_tree?' do
    it 'returns false if it is not a tree' do
      expect(subject.tree?(1, 1)).to be false
    end

    it 'returns true if it is a tree' do
      expect(subject.tree?(0, 1)).to be true
    end

    context 'when going further east' do
      it 'returns false if it is not a tree' do
        expect(subject.tree?(12, 1)).to be false
      end

      it 'returns true if it is a tree' do
        expect(subject.tree?(11, 1)).to be true
      end
    end
  end
end

RSpec.describe Sled do
  let(:map_definition) { <<~EOM
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
  EOM
  }
  let(:map) { Map.new(map_definition) }
  let(:subject) { described_class.new(map) }

  describe '.count_trees' do
    it 'counts the number of trees with the slope defined' do
      expect(subject.count_trees(3, 1)).to eql 7
    end
  end
end
