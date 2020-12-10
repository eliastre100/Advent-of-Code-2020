class PassportManager
  attr_reader :passports

  def initialize
    @passports = []
  end

  def add_passport(passport)
    @passports << passport
  end

  def valid_passports
    @passports.select(&:valid?)
  end
end
