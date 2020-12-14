require 'rspec'
require_relative '../../day 11/room'

RSpec.describe Room do
  let(:room_schema) { <<~EOR
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
  EOR
  }
  let(:subject) { described_class.new(room_schema)}

  describe '#initialize' do
    it 'stores the room correctly' do
      expect(subject.height).to be 10
      expect(subject.width).to be 10
      expect(subject.positions[0]).to eql ['L', '.', 'L', 'L', '.', 'L', 'L', '.', 'L', 'L']
    end
  end

  describe '.update' do
    it 'keeps the seats' do
      subject.update

      expect(subject.positions[0][1]).to eql '.'
      expect(subject.positions[0][4]).to eql '.'
      expect(subject.positions[0][7]).to eql '.'
      expect(subject.positions[1][7]).to eql '.'
      expect(subject.positions[2][1]).to eql '.'
      expect(subject.positions[2][3]).to eql '.'
      expect(subject.positions[2][5]).to eql '.'
      expect(subject.positions[2][6]).to eql '.'
      expect(subject.positions[2][8]).to eql '.'
      expect(subject.positions[2][9]).to eql '.'
      expect(subject.positions[3][4]).to eql '.'
      expect(subject.positions[3][7]).to eql '.'
    end

    it 'moves the occupied seats' do
      subject.update

      expect(subject.positions[0][0]).to eql '#'
      expect(subject.positions[3][3]).to eql '#'
    end

    it 'frees the unoccupied seats' do
      subject.update
      subject.update

      expect(subject.positions[0][2]).to eql 'L'
      expect(subject.positions[4][2]).to eql 'L'
    end

    it 'update the generation count' do
      subject.update
      subject.update
      subject.update

      expect(subject.generation).to be 3
    end

    it 'returns false when it is stabilized' do
      subject.update
      subject.update
      subject.update
      subject.update
      subject.update
      subject.update
      subject.update

      expect(subject.update).to be false
    end

    context 'with the view detection method' do
      it 'updates the map accordingly' do
        subject.update(method: :view)
        subject.update(method: :view)

        expect(subject.visualization).to eql <<~EOM.chomp
          #.LL.LL.L#
          #LLLLLL.LL
          L.L.L..L..
          LLLL.LL.LL
          L.LL.LL.LL
          L.LLLLL.LL
          ..L.L.....
          LLLLLLLLL#
          #.LLLLLL.L
          #.LLLLL.L#
        EOM
      end
    end
  end

  describe '.occupied_seats' do
    it 'counts the correct number of occupied seats' do
      subject.update
      expect(subject.occupied_seats).to be 71
    end
  end
end
