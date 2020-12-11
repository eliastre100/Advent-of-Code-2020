require 'rspec'
require_relative '../../day 06/group'
require_relative '../../day 06/group_manager'

RSpec.describe Group do
  let(:subject) { described_class.new }

  describe '.add_answer' do
    it 'adds the given answers' do
      subject.add_answers('ABCE')

      expect(subject.answers).to eql ['A', 'B', 'C', 'E']
    end

    it 'does not add duplicates' do
      subject.add_answers('ABCE')
      subject.add_answers('BF')

      expect(subject.answers).to eql ['A', 'B', 'C', 'E', 'F']
    end
  end

  describe '.number_answers' do
    it 'returns the number of answers' do
      subject.add_answers('ABCE')

      expect(subject.number_answers).to be 4
    end
  end
end

RSpec.describe GroupManager do
  let(:subject) { GroupManager.new }

  describe '.add_answers' do
    it 'add the answers to the last group' do
      subject.add_answers 'ABCD'
      subject.add_answers 'E'

      expect(subject.groups.last.answers).to eql ['A', 'B', 'C', 'D', 'E']
    end

    it 'creates a new group for an empty line' do
      subject.add_answers 'ABCD'
      subject.add_answers ''
      subject.add_answers 'E'

      expect(subject.groups.count).to be 2
      expect(subject.groups.first.answers).to eql ['A', 'B', 'C', 'D']
      expect(subject.groups.last.answers).to eql ['E']
    end
  end
end
