class Passport
  attr_reader :birth_year, :issue_year, :expiration_year, :height, :hair_color, :eye_color, :passport_id, :country_id
  
  def initialize(byr: nil, iyr: nil, eyr: nil, hgt: nil, hcl: nil, ecl: nil, pid: nil, cid: nil)
    self.birth_year = byr      unless byr.nil?
    self.issue_year = iyr      unless iyr.nil?
    self.expiration_year = eyr unless eyr.nil?
    self.height = hgt          unless hgt.nil?
    self.hair_color = hcl      unless hcl.nil?
    self.eye_color = ecl       unless ecl.nil?
    self.passport_id = pid     unless pid.nil?
    self.country_id = cid      unless cid.nil?
  end
    
  def birth_year=(year)
    set_attribute_value(:birth_year, year)
  end
  alias byr= birth_year=

  def issue_year=(year)
    set_attribute_value(:issue_year, year)
  end
  alias iyr= issue_year=

  def expiration_year=(year)
    set_attribute_value(:expiration_year, year)
  end
  alias eyr= expiration_year=

  def height=(height)
    set_attribute_value(:height, height)
  end
  alias hgt= height=

  def hair_color=(color)
    set_attribute_value(:hair_color, color)
  end
  alias hcl= hair_color=

  def eye_color=(color)
    set_attribute_value(:eye_color, color)
  end
  alias ecl= eye_color=

  def passport_id=(id)
    set_attribute_value(:passport_id, id)
  end
  alias pid= passport_id=

  def country_id=(id)
    set_attribute_value(:country_id, id)
  end
  alias cid= country_id=

  def valid?
    valid_birth? &&
      valid_issue_year? &&
      valid_expiration_year? &&
      valid_height? &&
      valid_hair_color? &&
      valid_eye_color? &&
      valid_passport?
  end

  private

  def valid_birth?
    birth_year.to_s.size == 4 && birth_year.to_i >= 1920 && birth_year.to_i <= 2002
  end

  def valid_issue_year?
    issue_year.to_s.size == 4 && issue_year.to_i >= 2010 && issue_year.to_i <= 2020
  end

  def valid_expiration_year?
    expiration_year.to_s.size == 4 && expiration_year.to_i >= 2020 && expiration_year.to_i <= 2030
  end

  def valid_height?
    (height.to_s.end_with?('cm') && height.to_i >= 150 && height.to_i <= 193) ||
      (height.to_s.end_with?('in') && height.to_i >= 59 && height.to_i <= 76)
  end

  def valid_hair_color?
    hair_color.to_s.match?(/^#[0-9a-f]{6}$/)
  end

  def valid_passport?
    passport_id.to_s.match?(/^[0-9]{9}$/)
  end

  def valid_eye_color?
    %w[amb blu brn gry grn hzl oth].include?(eye_color)
  end
  
  def set_attribute_value(attribute_name, value)
    raise "#{attribute_name} have already been defined" unless instance_variable_get(:"@#{attribute_name}").nil?

    instance_variable_set(:"@#{attribute_name}", value)
  end
end
