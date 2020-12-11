require 'rspec'
require_relative '../../day 06/group'
require_relative '../../day 06/group_manager'

RSpec.describe Group do
  let(:subject) { described_class.new }

  describe '.add_answer' do
    context 'unique answers' do
      it 'adds the given answers' do
        subject.add_answers('ABCE')

        expect(subject.unique_answers).to eql ['A', 'B', 'C', 'E']
      end

      it 'does not add duplicates' do
        subject.add_answers('ABCE')
        subject.add_answers('BF')

        expect(subject.unique_answers).to eql ['A', 'B', 'C', 'E', 'F']
      end
    end

    context 'answers' do
      it 'adds the answer' do
        subject.add_answers('ABCE')
        subject.add_answers('BF')

        expect(subject.answers.count).to be 2
        expect(subject.answers.first).to eql ['A', 'B', 'C', 'E']
        expect(subject.answers.last).to eql ['B', 'F']
      end
    end
  end

  describe '.unanimous_answers' do
    it 'returns only the answer all responder have gaven' do
      subject.add_answers('ABCE')
      subject.add_answers('BFC')

      expect(subject.unanimous_answers).to eql ['B', 'C']
    end
  end
end

RSpec.describe GroupManager do
  let(:subject) { GroupManager.new }

  describe '.add_answers' do
    it 'add the answers to the last group' do
      subject.add_answers 'ABCD'
      subject.add_answers 'E'

      expect(subject.groups.last.unique_answers).to eql ['A', 'B', 'C', 'D', 'E']
    end

    it 'creates a new group for an empty line' do
      subject.add_answers 'ABCD'
      subject.add_answers ''
      subject.add_answers 'E'

      expect(subject.groups.count).to be 2
      expect(subject.groups.first.unique_answers).to eql ['A', 'B', 'C', 'D']
      expect(subject.groups.last.unique_answers).to eql ['E']
    end
  end
end
