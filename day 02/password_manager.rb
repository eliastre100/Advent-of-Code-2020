class PasswordManager
  attr_reader :passwords

  def initialize
    @passwords = []
  end

  def add_password(password, rule_definition)
    @passwords << { password: password, rule: Rule.new(rule_definition) }
  end

  def valid_passwords
    passwords.map do |password_set|
      password_set[:password] if password_set[:rule].valid? password_set[:password]
    end.compact
  end

  class Rule
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
end
