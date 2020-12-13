require 'rspec'
require_relative '../../day 09/xmas_protocol'

RSpec.describe XMASProtocol do
  let(:stream) { <<~EOS
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
EOS
}
  let(:subject) { described_class.new(5) }

  describe '#initialize' do
    it 'sets the correct detection range' do
      expect(subject.detection_range).to be 5
    end
  end

  describe '.add_frame' do
    it 'adds the frame' do
      subject.add_frame('35')
      subject.add_frame('20')

      expect(subject.frames).to eql([{ value: 35, sums: [] }, { value: 20, sums: [55] }])
    end

    it 'computes its available sums' do
      subject.add_frame('35')
      subject.add_frame('20')
      subject.add_frame('15')
      subject.add_frame('15')

      expect(subject.frames).to eql([
                                      { value: 35, sums: [] },
                                      { value: 20, sums: [55] },
                                      { value: 15, sums: [35, 50] },
                                      { value: 15, sums: [30, 35, 50] }
                                    ])
    end

    it 'computes its available sums only up to the detection range' do
      subject.add_frame('35')
      subject.add_frame('20')
      subject.add_frame('15')
      subject.add_frame('25')
      subject.add_frame('47')
      subject.add_frame('40')

      puts subject.frames.inspect
      expect(subject.frames).to eql([
                                      { value: 35, sums: [] },
                                      { value: 20, sums: [55] },
                                      { value: 15, sums: [35, 50] },
                                      { value: 25, sums: [40, 45, 60] },
                                      { value: 47, sums: [72, 62, 67, 82] },
                                      { value: 40, sums: [87, 65, 55, 60] },
                                    ])
    end
  end

  describe '.weakness' do
    it 'finds the weakness' do
      [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576].each { |frame| subject.add_frame frame }

      expect(subject.weakness).to eql({ frame: 15, value: 127 })
    end
  end
end
