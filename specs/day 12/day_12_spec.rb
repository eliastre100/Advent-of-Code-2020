require 'rspec'
require_relative '../../day 12/ship'

RSpec.describe Ship do
  let(:subject) { described_class.new(:east) }

  describe '#initialize' do
    it 'is facing the correct direction' do
      expect(subject.direction).to be :east
    end

    it 'starts at (0, 0)' do
      expect(subject.position).to eql({ x: 0, y: 0 })
    end
  end

  describe '.north' do
    it 'moves the ship to the north' do
      subject.north(10)

      expect(subject.position).to eql({ x: 0, y: 10 })
    end
  end

  describe '.south' do
    it 'moves the ship to the south' do
      subject.south(10)

      expect(subject.position).to eql({ x: 0, y: -10 })
    end
  end

  describe '.east' do
    it 'moves the ship to the east' do
      subject.east(10)

      expect(subject.position).to eql({ x: 10, y: 0 })
    end
  end

  describe '.west' do
    it 'moves the ship to the west' do
      subject.west(10)

      expect(subject.position).to eql({ x: -10, y: 0 })
    end
  end

  describe '.left' do
    it 'turns the ship to the left' do
      expect(subject.direction).to be :east

      subject.left(90)
      expect(subject.direction).to be :north

      subject.left(90)
      expect(subject.direction).to be :west

      subject.left(90)
      expect(subject.direction).to be :south

      subject.left(90)
      expect(subject.direction).to be :east
    end

    it 'sets the correct cap degrees' do
      expect(subject.cap).to be 90

      subject.left(46)
      expect(subject.cap).to be 44
      expect(subject.direction).to be :north
    end
  end

  describe '.right' do
    it 'turns the ship to the right' do
      expect(subject.direction).to be :east

      subject.right(90)
      expect(subject.direction).to be :south

      subject.right(90)
      expect(subject.direction).to be :west

      subject.right(90)
      expect(subject.direction).to be :north

      subject.right(90)
      expect(subject.direction).to be :east
    end

    it 'sets the correct cap degrees' do
      expect(subject.cap).to be 90

      subject.right(46)
      expect(subject.cap).to be 136
      expect(subject.direction).to be :south
    end
  end

  describe '.forward' do
    it 'moves in the direction of the ship' do
      expect(subject.direction).to be :east
      expect(subject.position).to eql({ x: 0, y: 0 })

      subject.forward(1)
      expect(subject.position).to eql({ x: 1, y: 0 })

      subject.left(90)
      subject.forward(2)
      expect(subject.position).to eql({x: 1, y: 2 })

      subject.left(90)
      subject.forward(3)
      expect(subject.position).to eql({ x: -2, y: 2 })

      subject.left(90)
      subject.forward(4)
      expect(subject.position).to eql({ x: -2, y: -2 })
    end
  end

  describe '.manhattan_distance' do
    it 'gives the correct distance' do
      subject.north(150)
      subject.west(500)

      expect(subject.manhattan_distance).to be 650
    end
  end

  describe '.handle_instruction' do
    it 'calls the north method' do
      expect(subject).to receive(:north).with(10)

      subject.handle('N10')
    end

    it 'calls the east method' do
      expect(subject).to receive(:east).with(10)

      subject.handle('E10')
    end

    it 'calls the south method' do
      expect(subject).to receive(:south).with(10)

      subject.handle('S10')
    end

    it 'calls the west method' do
      expect(subject).to receive(:west).with(10)

      subject.handle('W10')
    end

    it 'calls the left method' do
      expect(subject).to receive(:left).with(90)

      subject.handle('L90')
    end

    it 'calls the right method' do
      expect(subject).to receive(:right).with(90)

      subject.handle('R90')
    end

    it 'calls the forward method' do
      expect(subject).to receive(:forward).with(10)

      subject.handle('F10')
    end
  end
end
