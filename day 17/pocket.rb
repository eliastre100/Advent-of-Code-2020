class Pocket
  ACTIVE_STATE_REPRESENTATION = '#'
  INACTIVE_STATE_REPRESENTATION = '.'

  def initialize(initial_state = '')
    @status = {}
    define_initial_state(initial_state)
  end

  def set_status(status, x, y, z)
    if status == :active
      @status["#{x}-#{y}-#{z}"] = { status: :active, x: x, y: y, z: z }
    else
      @status.delete("#{x}-#{y}-#{z}")
    end
  end

  def active?(x, y, z)
    @status.dig("#{x}-#{y}-#{z}", :status) == :active
  end

  def inactive?(x, y, z)
    !active?(x, y, z)
  end
  require 'awesome_print'
  def apply_cycle
    neighbors_counts = generate_neighbors_counts
    actions = update_inactive_cubes(neighbors_counts)
    actions += update_active_cubes(neighbors_counts)

    apply_updates(actions)
  end

  def display
    origin = pocket_origin
    last = pocket_end
    puts "x min: #{origin[:x]}, y min: #{origin[:y]}, z min: #{origin[:z]}"
    puts "x max: #{last[:x]}, y max: #{last[:y]}, z max: #{last[:z]}"

    (origin[:z]..last[:z]).each do |z|
      print "\n"
      puts "z = #{z}"
      (origin[:y]..last[:y]).each do |y|
        (origin[:x]..last[:x]).each do |x|
          print active?(x, y, z) ? ACTIVE_STATE_REPRESENTATION : INACTIVE_STATE_REPRESENTATION
        end
        print "\n"
      end
    end
  end

  def active_cubes
    @status.map do |_, cube|
      { x: cube[:x], y: cube[:y], z: cube[:z] } if active?(cube[:x], cube[:y], cube[:z])
    end.compact
  end

  private

  def define_initial_state(state)
    state.split("\n").each_with_index do |row, y|
      row.split('').each_with_index do |cell, x|
        set_status(:active, x, y, 0) if cell == ACTIVE_STATE_REPRESENTATION
      end
    end
  end

  def generate_neighbors_counts
    {}.tap do |neighbors_count|
      @status.each do |_, cube|
        next if cube[:status] != :active
        neighbors_positions(cube[:x], cube[:y], cube[:z]).each do |position|
          neighbors_count["#{position[:x]}-#{position[:y]}-#{position[:z]}"] = {
            count: (neighbors_count.dig("#{position[:x]}-#{position[:y]}-#{position[:z]}", :count) || 0) + 1,
            x: position[:x],
            y: position[:y],
            z: position[:z]
          }
        end
      end
    end
  end

  def neighbors_positions(x, y, z)
    (-1..1).map do |x_modificator|
      (-1..1).map do |y_modificator|
        (-1..1).map do |z_modificator|
          { x: x + x_modificator, y: y + y_modificator, z: z + z_modificator } unless x_modificator == 0 && y_modificator == 0 && z_modificator == 0
        end
      end
    end.flatten.compact
  end

  def update_inactive_cubes(neighbors_counts)
    neighbors_counts.map do |_, neighbour|
      next nil if active?(neighbour[:x], neighbour[:y], neighbour[:z])

      { action: :active, x: neighbour[:x], y: neighbour[:y], z: neighbour[:z] } if neighbour[:count] == 3
    end.compact
  end

  def update_active_cubes(neighbors_counts)
    @status.map do |_, cube|
      next nil if cube[:status] != :active

      { action: :inactive, x: cube[:x], y: cube[:y], z: cube[:z] } unless [2, 3].include?(neighbors_counts.dig("#{cube[:x]}-#{cube[:y]}-#{cube[:z]}", :count))
    end.compact
  end

  def apply_updates(updates)
    updates.each do |update|
      set_status(update[:action], update[:x], update[:y], update[:z])
    end
  end

  def pocket_origin
    {
      x: @status.min_by { |_, cube| cube[:x] }.last[:x] || 0,
      y: @status.min_by { |_, cube| cube[:y] }.last[:y] || 0,
      z: @status.min_by { |_, cube| cube[:z] }.last[:z] || 0
    }
  end

  def pocket_end
    {
      x: @status.max_by { |_, cube| cube[:x] }.last[:x] || 0,
      y: @status.max_by { |_, cube| cube[:y] }.last[:y] || 0,
      z: @status.max_by { |_, cube| cube[:z] }.last[:z] || 0
    }
  end
end
