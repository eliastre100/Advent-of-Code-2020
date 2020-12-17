class Pocket
  ACTIVE_STATE_REPRESENTATION = '#'
  INACTIVE_STATE_REPRESENTATION = '.'

  def initialize(initial_state = '', use_w: false)
    @status = {}
    define_initial_state(initial_state)
    @use_w = use_w
  end

  def set_status(status, x, y, z, w = 0)
    if status == :active
      @status["#{x}-#{y}-#{z}-#{w}"] = { status: :active, x: x, y: y, z: z, w: w }
    else
      @status.delete("#{x}-#{y}-#{z}-#{w}")
    end
  end

  def active?(x, y, z, w = 0)
    @status.dig("#{x}-#{y}-#{z}-#{w}", :status) == :active
  end

  def inactive?(x, y, z, w = 0)
    !active?(x, y, z, w)
  end

  def apply_cycle
    neighbors_counts = generate_neighbors_counts
    actions = update_inactive_cubes(neighbors_counts)
    actions += update_active_cubes(neighbors_counts)

    apply_updates(actions)
  end

  def display
    origin = pocket_origin
    last = pocket_end
    puts "x min: #{origin[:x]}, y min: #{origin[:y]}, z min: #{origin[:z]}, w min: #{origin[:w]}"
    puts "x max: #{last[:x]}, y max: #{last[:y]}, z max: #{last[:z]}, w max: #{last[:w]}"

    (origin[:z]..last[:z]).each do |z|
      (origin[:w]..last[:w]).each do |w|
        print "\n"
        puts "z = #{z}, w = #{w}"
        (origin[:y]..last[:y]).each do |y|
          (origin[:x]..last[:x]).each do |x|
            print active?(x, y, z, w) ? ACTIVE_STATE_REPRESENTATION : INACTIVE_STATE_REPRESENTATION
          end
          print "\n"
        end
      end
    end
  end

  def active_cubes
    @status.map do |_, cube|
      { x: cube[:x], y: cube[:y], z: cube[:z], w: cube[:w] } if active?(cube[:x], cube[:y], cube[:z], cube[:w])
    end.compact
  end

  private

  def define_initial_state(state)
    state.split("\n").each_with_index do |row, y|
      row.split('').each_with_index do |cell, x|
        set_status(:active, x, y, 0, 0) if cell == ACTIVE_STATE_REPRESENTATION
      end
    end
  end

  def generate_neighbors_counts
    {}.tap do |neighbors_count|
      @status.each do |_, cube|
        next if cube[:status] != :active

        #puts neighbors_positions(cube[:x], cube[:y], cube[:z], cube[:w]).inspect

        neighbors_positions(cube[:x], cube[:y], cube[:z], cube[:w]).each do |position|
          neighbors_count["#{position[:x]}-#{position[:y]}-#{position[:z]}-#{position[:w]}"] = {
            count: (neighbors_count.dig("#{position[:x]}-#{position[:y]}-#{position[:z]}-#{position[:w]}", :count) || 0) + 1,
            x: position[:x],
            y: position[:y],
            z: position[:z],
            w: position[:w]
          }
        end
      end
    end
  end

  def neighbors_positions(x, y, z, w)
    w_range = @use_w ? (-1..1) : (0..0)
    w_range.map do |w_modificator|
      (-1..1).map do |x_modificator|
        (-1..1).map do |y_modificator|
          (-1..1).map do |z_modificator|
            { x: x + x_modificator, y: y + y_modificator, z: z + z_modificator, w: w + w_modificator } unless x_modificator == 0 && y_modificator == 0 && z_modificator == 0 && w_modificator == 0
          end
        end
      end
    end.flatten.compact
  end

  def update_inactive_cubes(neighbors_counts)
    neighbors_counts.map do |_, neighbour|
      next nil if active?(neighbour[:x], neighbour[:y], neighbour[:z], neighbour[:w])

      { action: :active, x: neighbour[:x], y: neighbour[:y], z: neighbour[:z], w: neighbour[:w] } if neighbour[:count] == 3
    end.compact
  end

  def update_active_cubes(neighbors_counts)
    @status.map do |_, cube|
      next nil if cube[:status] != :active

      { action: :inactive, x: cube[:x], y: cube[:y], z: cube[:z], w: cube[:w] } unless [2, 3].include?(neighbors_counts.dig("#{cube[:x]}-#{cube[:y]}-#{cube[:z]}-#{cube[:w]}", :count))
    end.compact
  end

  def apply_updates(updates)
    updates.each do |update|
      set_status(update[:action], update[:x], update[:y], update[:z], update[:w])
    end
  end

  def pocket_origin
    {
      x: @status.min_by { |_, cube| cube[:x] }.last[:x] || 0,
      y: @status.min_by { |_, cube| cube[:y] }.last[:y] || 0,
      z: @status.min_by { |_, cube| cube[:z] }.last[:z] || 0,
      w: @status.min_by { |_, cube| cube[:w] }.last[:w] || 0
    }
  end

  def pocket_end
    {
      x: @status.max_by { |_, cube| cube[:x] }.last[:x] || 0,
      y: @status.max_by { |_, cube| cube[:y] }.last[:y] || 0,
      z: @status.max_by { |_, cube| cube[:z] }.last[:z] || 0,
      w: @status.max_by { |_, cube| cube[:w] }.last[:w] || 0
    }
  end
end
