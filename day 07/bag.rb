class Bag
  attr_reader :color
  attr_reader :containable

  def initialize(rule)
    rule_parts = rule.split(' contain ')
    @color = strip_bag_string(rule_parts.first.strip)
    @containable = rule_parts.last.split(',')
                             .map { |color| color.strip.delete_suffix('.') }
                             .map(&method(:strip_bag_string))
                             .map(&method(:strip_bag_number))
                             .reject { |bag| bag.first == 'no other' }
                             .to_h
    List.registered_bags << self
  end

  def can_contain?(other)
    containable.has_key?(other.color) || !containable.detect { |bag_color, _| List.get_bag(bag_color)&.can_contain?(other) }.nil?
  end

  def nested_bags
    (containable.map(&method(:bags_nested_for)) + [containable]).compact.reduce do |acc, value|
      acc.merge(value) { |_, value1, value2| value1 + value2 }
    end
  end

  private

  def strip_bag_string(full_name)
    full_name.gsub(/(bag|bags) *$/, '').strip
  end

  def strip_bag_number(full_name)
    quantity = full_name.match(/^ *[0-9]*/)[0].to_i
    [full_name.gsub(quantity.to_s, '').strip, quantity]
  end

  def bags_nested_for(color)
    (List.get_bag(color.first)&.nested_bags || {}).map { |nested_color, quantity| [nested_color, quantity * color.last] }.to_h
  end

  class List
    class << self
      def registered_bags
        @registered_bags ||= []
      end

      def get_bag(name)
        registered_bags.detect { |bag| bag.color == name }
      end
    end
  end
end
