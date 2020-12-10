# frozen_string_literal: true
require 'rspec'
require_relative '../../day 02/password_manager'

RSpec.describe PasswordManager do
  let(:subject) { described_class.new }

  describe '.add_password' do
    it 'stores the password and its rule' do
      subject.add_password('password', '1-10 a')

      expect(subject.passwords.first[:password]).to eql 'password'
      expect(subject.passwords.first[:rule].minimum).to eql 1
      expect(subject.passwords.first[:rule].maximum).to eql 10
      expect(subject.passwords.first[:rule].character).to eql 'a'
    end

    context 'with an invalid rule' do
      it 'raises an exception' do
        expect do
          subject.add_password('password', 'this is not a valid rule')
        end.to raise_error ArgumentError
      end
    end
  end

  describe '.valid_passwords' do
    it 'returns the valid passwords' do
      subject.add_password('abcde', '1-3 a')
      subject.add_password('cdefg', '1-3 b')
      subject.add_password('ccccccccc', '2-9 c')

      expect(subject.valid_passwords).to eql ['abcde', 'ccccccccc']
    end
  end

  context 'with the OfficialTobogganCorporatePolicyRule rule' do
    let(:subject) { described_class.new(PasswordManager::SledRentalRule) }

    it 'has the same result as the challenge' do
      subject.add_password('abcde', '1-3 a')
      subject.add_password('cdefg', '1-3 b')
      subject.add_password('ccccccccc', '2-9 c')

      expect(subject.valid_passwords).to eql ['abcde']
    end
  end
end

RSpec.describe PasswordManager::SledRentalRule do
  let(:subject) { described_class.new('1-3 a') }
  
  describe '.valid?' do
    it 'returns true for a valid password' do
      expect(subject.valid?("abcda")).to be true
    end

    it 'returns false for password with too many times the character' do
      expect(subject.valid?("abcdaaa")).to be false
    end

    it 'returns false for password with not enough times the character' do
      expect(subject.valid?("bcder")).to be false
    end
  end
end

RSpec.describe PasswordManager::OfficialTobogganCorporatePolicyRule do
  let(:subject) { described_class.new('1-3 a') }

  describe '.valid?' do
    it 'returns true for a valid password for the first occurance' do
      expect(subject.valid?("abcda")).to be true
    end

    it 'returns true for a valid password for the second occurance' do
      expect(subject.valid?("bcada")).to be true
    end

    it 'returns false for password with no valid character positions' do
      expect(subject.valid?("babaaaaaa")).to be false
    end

    it 'returns false when the two characters have the required value' do
      expect(subject.valid?("aaaaaaaaa")).to be false
    end

    context 'if the rule mention a 0 character' do
      let(:subject) { described_class.new('0-3 a') }

      it "shouldn't crash and keep on searching" do
        expect(subject.valid?('bbabb')).to be true
        expect(subject.valid?('bbbbb')).to be false
      end
    end
  end
end
