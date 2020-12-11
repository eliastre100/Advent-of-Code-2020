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
    List.registered_bags << self
  end

  def can_contain?(other)
    containable.include?(other.color) || !containable.detect { |bag_color| List.get_bag(bag_color)&.can_contain?(other) }.nil?
  end

  private

  def strip_bag_string(full_name)
    full_name.gsub(/(bag|bags) *$/, '').strip
  end

  def strip_bag_number(full_name)
    full_name.gsub(/^ *[0-9]*/, '').strip
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
