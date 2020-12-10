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
end

RSpec.describe PasswordManager::Rule do
  let(:subject) { PasswordManager::Rule.new('1-3 a') }
  
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
