require 'rspec'
require_relative '../../day 08/game_console'

RSpec.describe GameConsole do
  let(:instructions) { <<~EOI
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
  EOI
  }
  let(:subject) { described_class.new(instructions) }

  describe '#initialize' do
    it 'defines all the instructions' do
      expect(subject.instructions.count).to be 9
      expect(subject.instructions).to eql [
                                            { type: :nop, value: 0, visited: false },
                                            { type: :acc, value: 1, visited: false },
                                            { type: :jmp, value: 4, visited: false },
                                            { type: :acc, value: 3, visited: false },
                                            { type: :jmp, value: -3, visited: false },
                                            { type: :acc, value: -99, visited: false },
                                            { type: :acc, value: 1, visited: false },
                                            { type: :jmp, value: -4, visited: false },
                                            { type: :acc, value: 6, visited: false }
                                          ]
    end

    it 'defines an accumulator at 0' do
      expect(subject.accumulator).to be 0
    end
  end

  describe '.execute' do
    it 'stops when an infinite loop is encountered' do
      expect(subject.execute).to eql({ error: :infinite_loop, line: 2 })
    end

    it 'sets the correct accumulator value' do
      subject.execute
      expect(subject.accumulator).to be 5
    end

    it 'terminates successfully if trying to execute the line after the last instruction' do
      subject.instructions.first[:type] = :jmp
      subject.instructions.first[:value] = 8

      expect(subject.execute).to eql({ status: :successful, value: 6 })
    end
  end

  describe 'recover' do
    it 'recovers through a nop' do
      subject.instructions.first[:type] = :nop
      subject.instructions.first[:value] = 8

      expect(subject.execute).to eql({ error: :infinite_loop, line: 2 })

      recover_report = subject.recover

      expect(recover_report).to eql({ status: :successful, type: :nop, line: 1 })
      expect(subject.execute).to eql({ error: :infinite_loop, line: 2 })
    end

    it 'recovers through a jmp' do
      expect(subject.execute).to eql({ error: :infinite_loop, line: 2 })

      recover_report = subject.recover

      expect(recover_report).to eql({ status: :successful, type: :jmp, line: 8 })
    end
  end

  describe '.apply_patch' do
    it 'fixes a nop issue' do
      subject.instructions.first[:type] = :nop
      subject.instructions.first[:value] = 8

      expect(subject.execute).to eql({ error: :infinite_loop, line: 2 })

      subject.apply_patch({ status: :successful, type: :nop, line: 1 })

      expect(subject.execute).to eql({ status: :successful, value: 6 })
    end

    it 'fixes a jmp issue' do
      expect(subject.execute).to eql({ error: :infinite_loop, line: 2 })

      subject.apply_patch({ status: :successful, type: :jmp, line: 8 })

      expect(subject.execute).to eql({ status: :successful, value: 8 })
    end
  end
end

