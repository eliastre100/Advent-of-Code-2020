require 'rspec'
require_relative '../../day 04/passport'
require_relative '../../day 04/passport_reader'
require_relative '../../day 04/passport_manager'

RSpec.describe Passport do
  describe '#initialize' do
    it 'defines the correct fields' do
      subjet = described_class.new(byr: 'birth', iyr: 'issue', eyr: 'expiration', hgt: 'height', hcl: 'hair', ecl: 'eye', pid: 'passport', cid: 'country')

      expect(subjet.birth_year).to eql 'birth'
    end
  end

  describe 'attributes' do
    it 'cannot be redefined' do
      subject = described_class.new

      subject.passport_id = 'id'

      expect {
        subject.passport_id = 'id bis'
      }.to raise_error 'passport_id have already been defined'
    end

    it 'cannot be redefined' do
      subject = described_class.new

      subject.passport_id = 'id'

      expect {
        subject.pid = 'id bis'
      }.to raise_error 'passport_id have already been defined'
    end
  end

  describe 'valid?' do
    it 'is valid with all the fields' do
      subject.expiration_year = '2020'
      subject.passport_id = '012345678'
      subject.country_id = '250'
      subject.eye_color = 'gry'
      subject.hair_color = '#000000'
      subject.height = '150cm'
      subject.issue_year = '2015'
      subject.birth_year = '1960'

      expect(subject.valid?).to be true
    end

    it 'is valid id country id is missing' do
      subject.expiration_year = '2020'
      subject.passport_id = '012345678'
      subject.eye_color = 'gry'
      subject.hair_color = '#000000'
      subject.height = '150cm'
      subject.issue_year = '2015'
      subject.birth_year = '1960'

      expect(subject.valid?).to be true
    end

    it 'is not valid if a field is missing' do
      subject.expiration_year = '2020'
      subject.passport_id = '012345678'
      subject.eye_color = 'gry'
      subject.hair_color = '#000000'
      subject.height = '150cm'
      subject.issue_year = '2015'

      expect(subject.valid?).to be false
    end

    describe 'individual attributes validation' do
      let(:subject) { described_class.new(byr: '1950', iyr: '2015', eyr: '2022', hgt: '160cm', hcl: '#000000', ecl: 'grn', pid: '012345678', cid: 'country') }

      it 'is valid' do
        expect(subject).to be_valid
      end

      describe 'birth_year' do
        it 'is not valid for a non date' do
          subject.instance_variable_set('@birth_year', 'not a date')

          expect(subject).not_to be_valid
        end

        it 'is not valid before 1920' do
          subject.instance_variable_set('@birth_year', '1919')

          expect(subject).not_to be_valid
        end

        it 'is not valid after 2002' do
          subject.instance_variable_set('@birth_year', '2003')

          expect(subject).not_to be_valid
        end
      end

      describe 'issue_year' do
        it 'is not valid for a non date' do
          subject.instance_variable_set('@issue_year', 'not a date')

          expect(subject).not_to be_valid
        end

        it 'is not valid before 2010' do
          subject.instance_variable_set('@issue_year', '2009')

          expect(subject).not_to be_valid
        end

        it 'is not valid after 2020' do
          subject.instance_variable_set('@issue_year', '2021')

          expect(subject).not_to be_valid
        end
      end

      describe 'expiration_year' do
        it 'is not valid for a non date' do
          subject.instance_variable_set('@expiration_year', 'not a date')

          expect(subject).not_to be_valid
        end

        it 'is not valid before 2020' do
          subject.instance_variable_set('@expiration_year', '2019')

          expect(subject).not_to be_valid
        end

        it 'is not valid after 2030' do
          subject.instance_variable_set('@expiration_year', '2031')

          expect(subject).not_to be_valid
        end
      end

      describe 'height' do
        it 'is not valid if it doesnt end with cm or in' do
          subject.instance_variable_set('@height', '152')

          expect(subject).not_to be_valid
        end

        it 'must be more that 150cm and less than 193cm' do
          subject.instance_variable_set('@height', '149cm')
          expect(subject).not_to be_valid

          subject.instance_variable_set('@height', '194cm')
          expect(subject).not_to be_valid

          subject.instance_variable_set('@height', '160cm')
          expect(subject).to be_valid
        end

        it 'must be more than 59in and less than 76' do
          subject.instance_variable_set('@height', '58in')
          expect(subject).not_to be_valid

          subject.instance_variable_set('@height', '77in')
          expect(subject).not_to be_valid

          subject.instance_variable_set('@height', '60in')
          expect(subject).to be_valid
        end
      end

      describe 'hair color' do
        it 'must start by a #' do
          subject.instance_variable_set('@hair_color', '000000')
          expect(subject).not_to be_valid
        end

        it 'must contain 6 hexadecimal characters' do
          subject.instance_variable_set('@hair_color', '#zzzzzz')
          expect(subject).not_to be_valid

          subject.instance_variable_set('@hair_color', '#aaaaa')
          expect(subject).not_to be_valid
        end
      end

      describe 'eye color' do
        it 'should be within the list amb blu brn gry grn hzl oth' do
          subject.instance_variable_set('@eye_color', 'not')
          expect(subject).not_to be_valid

          ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].each do |value|
            subject.instance_variable_set('@eye_color', value)
            expect(subject).to be_valid
          end
        end
      end

      describe 'passport id' do
        it 'refuse any non digit' do
          subject.instance_variable_set('@passport_id', '000000s00')
          expect(subject).not_to be_valid
        end

        it 'must be nine digit' do
          subject.instance_variable_set('@passport_id', '00000000')
          expect(subject).not_to be_valid
        end
      end
    end
  end
end


RSpec.describe PassportReader do
  let(:subject) { described_class.new }

  describe '.read' do
    it 'can read in one time' do
      subject.read('iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929')

      passport = subject.extract_passport
      expect(passport.issue_year).to eql '2013'
      expect(passport.eye_color).to eql 'amb'
      expect(passport.country_id).to eql '350'
      expect(passport.expiration_year).to eql '2023'
      expect(passport.passport_id).to eql '028048884'
      expect(passport.hair_color).to eql '#cfa07d'
      expect(passport.birth_year).to eql '1929'
    end

    it 'can read in multiple times' do
      subject.read('iyr:2013 ecl:amb cid:350')
      subject.read('eyr:2023 pid:028048884 hcl:#cfa07d byr:1929')

      passport = subject.extract_passport
      expect(passport.issue_year).to eql '2013'
      expect(passport.eye_color).to eql 'amb'
      expect(passport.country_id).to eql '350'
      expect(passport.expiration_year).to eql '2023'
      expect(passport.passport_id).to eql '028048884'
      expect(passport.hair_color).to eql '#cfa07d'
      expect(passport.birth_year).to eql '1929'
    end
  end

  describe '.extract_passport' do
    it 'should make a new passport' do
      subject.read('iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929')
      subject.extract_passport

      passport = subject.extract_passport
      expect(passport.issue_year).to be_nil
      expect(passport.eye_color).to be_nil
      expect(passport.country_id).to be_nil
      expect(passport.expiration_year).to be_nil
      expect(passport.passport_id).to be_nil
      expect(passport.hair_color).to be_nil
      expect(passport.birth_year).to be_nil
    end
  end
end

RSpec.describe PassportManager do
  let(:subject) { described_class.new }

  describe ".add_passport" do
    it 'adds the passport' do
      passport = Passport.new(iyr: '2020')

      expect {
        subject.add_passport passport
      }.to(change { subject.passports})

      expect(subject.passports).to include passport
    end
  end

  describe '.valid_passports' do
    it 'returns the valid passports' do
      passport1 = Passport.new(byr: '1960', pid: '012345678', cid: '525', iyr: '2018', ecl: 'gry', eyr: '2022', hcl: '#000000', hgt: '160cm')
      passport2 = Passport.new(byr: '1960', pid: '013245678', cid: '525', ecl: 'gry', eyr: '2022', hcl: '#000000', hgt: '160cm')
      passport3 = Passport.new(byr: '1960', pid: '013245678', iyr: '2018', ecl: 'gry', eyr: '2022', hcl: '#000000', hgt: '160cm')

      subject.add_passport passport1
      subject.add_passport passport2
      subject.add_passport passport3

      expect(subject.valid_passports).to include passport1
      expect(subject.valid_passports).to include passport3
      expect(subject.valid_passports).not_to include passport2
    end
  end
end
