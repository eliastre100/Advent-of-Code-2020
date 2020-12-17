require 'rspec'
require_relative '../../day 17/pocket'

RSpec.describe Pocket do
  let(:initial_state) { <<~STATE
    .#.
    ..#
    ###
  STATE
  }
  let(:subject) { described_class.new(initial_state) }

  describe '#initialize' do
    it 'initialize the 0 z plan' do
      expect(subject.inactive?(0, 0, 0)).to be true
      expect(subject.active?(1, 0, 0)).to be true
      expect(subject.inactive?(2, 0, 0)).to be true
      expect(subject.inactive?(0, 1, 0)).to be true
      expect(subject.inactive?(1, 1, 0)).to be true
      expect(subject.active?(2, 1, 0)).to be true
      expect(subject.active?(0, 2, 0)).to be true
      expect(subject.active?(1, 2, 0)).to be true
      expect(subject.active?(2, 2, 0)).to be true
    end
  end

  describe '.set_status' do
    it 'sets the cube active' do
      expect(subject.active?(10, 11, 12)).to be false

      subject.set_status(:active, 10, 11, 12)

      expect(subject.active?(10, 11, 12)).to be true
    end

    it 'sets the cube inactive' do
      subject.set_status(:active, 10, 11, 12)
      expect(subject.inactive?(10, 11, 12)).to be false

      subject.set_status(:inactive, 10, 11, 12)

      expect(subject.inactive?(10, 11, 12)).to be true
    end
  end

  describe '.active?' do
    it 'returns true if the cube is explicitly active' do
      subject.set_status(:active, 10, 11, 12)

      expect(subject.active?(10, 11, 12)).to be true
    end

    it 'returns false when the cube is explicitly inactive' do
      subject.set_status(:inactive, 10, 11, 12)

      expect(subject.active?(10, 11, 12)).to be false
    end

    it 'returns false when the cube have never been defined' do
      expect(subject.active?(10, 11, 12)).to be false
    end
  end

  describe '.inactive?' do
    it 'returns false if the cube is explicitly active' do
      subject.set_status(:active, 10, 11, 12)

      expect(subject.inactive?(10, 11, 12)).to be false
    end

    it 'returns true if the cube is explicitly inactive' do
      subject.set_status(:inactive, 10, 11, 12)

      expect(subject.inactive?(10, 11, 12)).to be true
    end

    it 'returns true if the cube have never been defined' do
      expect(subject.inactive?(10, 11, 12)).to be true
    end
  end

  describe '.display' do
    it 'displays the representation of the pocket' do
      output = <<~REPRESENTATION
        x min: 0, y min: 0, z min: 0
        x max: 2, y max: 2, z max: 0

        z = 0
        .#.
        ..#
        ###
      REPRESENTATION

      expect {
        subject.display
      }.to output(output).to_stdout
    end
  end

  describe '.apply_cycle' do
    it 'applies the active state after the cycle' do
      subject.apply_cycle

      [
        [0, 1, -1], [2, 2, -1], [1, 3, -1],
        [0, 1, 0], [2, 1, 0], [1, 2, 0], [2, 2, 0], [1, 3, 0],
        [0, 1, 1], [2, 2, 1], [1, 3, 1]
      ].each do |coordinates|
        expect(subject.active?(coordinates[0], coordinates[1], coordinates[2])).to be true
      end
    end
  end

  describe '.active_cubes' do
    it 'returns the active cubes' do
      expect(subject.active_cubes).to eql [
        { x: 1, y: 0, z: 0 },
        { x: 2, y: 1, z: 0 },
        { x: 0, y: 2, z: 0 },
        { x: 1, y: 2, z: 0 },
        { x: 2, y: 2, z: 0 }
      ]
    end
  end
end
