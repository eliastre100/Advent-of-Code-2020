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
      (boundary.first..boundary.last)
    end
    update_valid_values(@rules[kind])
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

  private

  def update_valid_values(values_iterators)
    values_iterators.each do |values|
      values.each do |value|
        @valid_values << value
      end
    end
    @valid_values.compact!
    @valid_values.uniq!
  end

  def invalid_numbers(ticket)
    ticket.select(&method(:invalid_value?))
  end

  def invalid_value?(value)
    !@valid_values.include?(value)
  end
end
