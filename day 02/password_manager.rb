class PasswordManager
  attr_reader :passwords

  def initialize(rule_class = SledRentalRule)
    @passwords = []
    @rule_class = rule_class
  end

  def add_password(password, rule_definition)
    @passwords << { password: password, rule: @rule_class.new(rule_definition) }
  end

  def valid_passwords
    passwords.map do |password_set|
      password_set[:password] if password_set[:rule].valid? password_set[:password]
    end.compact
  end

  class SledRentalRule
    attr_reader :character
    attr_reader :minimum
    attr_reader :maximum

    def initialize(rule_definition)
      definitions = rule_definition.split(/[- ]/).map(&:strip)

      raise ArgumentError if definitions.size != 3

      @character = definitions.last
      @minimum = definitions.first.to_i
      @maximum = definitions[1].to_i
    end

    def valid?(password)
      time_character = password.scan(/#{character}/).length
      @minimum <= time_character && time_character <= @maximum
    end
  end

  class OfficialTobogganCorporatePolicyRule
    attr_reader :character
    attr_reader :positions

    def initialize(rule_definition)
      definitions = rule_definition.split(' ').map(&:strip)

      @character = definitions.last
      @positions = definitions.first.split('-').to_a.map(&:to_i)
    end

    def valid?(password)
      @positions.select do |position|
        position.positive? && password[position - 1] == @character
      end.size == 1
    end
  end
end
