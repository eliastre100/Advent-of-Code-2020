class Expression
  attr_reader :operation
  attr_reader :first_operand
  attr_reader :second_operand

  OPERATIONS = {
    '*': {
      level: 100, # Lower is better
      operation: :multiplication
    },
    '+': {
      level: 100,
      operation: :addition
    }
  }.freeze

  def initialize(str, operations_definitions = OPERATIONS)
    @operations_definitions = operations_definitions
    operator_idx = find_operator_idx(str)
    @operation = get_operation(operator_idx, str)
    set_operands(operator_idx, str)
  end

  def resolve
    send(operation)
  end

  def eql?(other)
    first_operand.eql?(other.first_operand) &&
      second_operand.eql?(other.second_operand) &&
      operation.eql?(other.operation)
  end

  def to_h
    {
      first_operand: first_operand.respond_to?(:to_h) ? first_operand.to_h : first_operand,
      second_operand: second_operand.respond_to?(:to_h) ? second_operand.to_h : second_operand,
      operation: operation
    }
  end

  private

  def get_operation(operator_idx, str)
    return :number if operator_idx.nil?
    @operations_definitions.dig(str[operator_idx].to_sym, :operation)
  end

  def find_operator_idx(str)
    parenthesis = 0
    index_operator = (0...str.size).reverse_each.max_by do |character_idx|
      character = str[character_idx]
      if character == '('
        parenthesis -= 1
      elsif character == ')'
        parenthesis += 1
      else
        next @operations_definitions[character.to_sym][:level] if @operations_definitions.key?(character.to_sym) && parenthesis.zero?
      end
      -1
    end
    @operations_definitions.key?(str[index_operator].to_sym) ? index_operator : nil
  end

  def set_operands(operator_idx, str)
    if operator_idx.nil?
      @first_operand = str.to_i
      @second_operand = nil
    else
      @first_operand = Expression.new(strip_first_parenthesis(str[0...operator_idx]))
      @second_operand = Expression.new(strip_first_parenthesis(str[(operator_idx + 1)..-1]))
    end
  end

  def strip_first_parenthesis(str)
    within_parenthesis = str.strip.match(/^\((.+)\)$/)
    return within_parenthesis[1] if !within_parenthesis.nil? && surrounded_by_parenthesis?(str.strip)
    str
  end

  def surrounded_by_parenthesis?(str)
    return false if str[0] != '(' || str[-1] != ')'
    parenthesis = 0
    str[1..-2].each_char do |character|
      if character == '('
        parenthesis += 1
      elsif character == ')'
        parenthesis -= 1
        return false if parenthesis.negative?
      end
    end
    true
  end

  # Operations

  def number
    first_operand
  end

  def multiplication
    first_operand.resolve * second_operand.resolve
  end

  def addition
    first_operand.resolve + second_operand.resolve
  end
end
