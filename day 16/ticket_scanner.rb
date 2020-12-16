class TicketScanner
  attr_reader :rules
  attr_reader :tickets

  def initialize
    @rules = {}
    @tickets = []
    @valid_values = []
  end

  def add_rule(kind, limits)
    @rules[kind] = limits.split('or').map(&:strip).map do |boundaries_str|
      boundary = boundaries_str.split('-').map(&:to_i)
      (boundary.first..boundary.last).to_a
    end.flatten
    @valid_values = (@valid_values + @rules[kind]).compact.uniq
  end

  def add_ticket(ticket)
    @tickets << ticket.split(',').map(&:to_i)
  end

  def invalid_tickets
    tickets.map do |ticket|
      invalid = invalid_numbers(ticket)
      if invalid.empty?
        nil
      else
        { ticket: ticket, invalid_values: invalid }
      end
    end.compact || []
  end

  def rules_ticket_index
    possibilities = valid_tickets.map(&method(:generate_ticket_possibilities))
    possibilities = keep_commons_possibilities(possibilities)
    simplify_possibilities(possibilities).map.with_index { |rules, position| [rules.first, position] }.to_h
  end

  private

  def valid_tickets
    tickets.select do |ticket|
      invalid_numbers(ticket).empty?
    end
  end

  def invalid_numbers(ticket)
    ticket.select(&method(:invalid_value?))
  end

  def invalid_value?(value)
    !@valid_values.include?(value)
  end

  def generate_ticket_possibilities(ticket)
    ticket.map.with_index do |ticket_value, idx|
      [idx, valid_rules(ticket_value)]
    end.to_h
  end

  def valid_rules(value)
    rules.select { |_, rule| rule.include?(value) }.map(&:first)
  end

  def keep_commons_possibilities(possibilities)
    ticket_size = possibilities.first.size
    rules_list = rules.map(&:first)

    (0..(ticket_size - 1)).map do |idx|
      possibilities.reduce(rules_list) do |acc, current_possibilities|
        next acc if current_possibilities[idx].empty?

        current_possibilities[idx] & acc
      end
    end
  end

  def simplify_possibilities(possibilities)
    return possibilities if simplified?(possibilities)
    isolated_rules = possibilities.select { |possibility| possibility.size == 1 }.map(&:first)

    simplify_possibilities(remove_impossible_values(possibilities, isolated_rules))
  end

  def simplified?(possibilities)
    possibilities.detect { |possibility| possibility.size > 1 }.nil?
  end

  def remove_impossible_values(possibilities, isolated_values)
    possibilities.map do |possibility|
      if possibility.size > 1
        possibility - isolated_values
      else
        possibility
      end
    end
  end
end
