class GameConsole
  attr_reader :accumulator
  attr_reader :instructions

  def initialize(boot_code)
    @instructions = boot_code.split("\n").map(&method(:generate_byte_code))
    @accumulator = 0
    @handlers = {
      nop: method(:nop),
      acc: method(:acc),
      jmp: method(:jmp)
    }
  end

  def execute
    @accumulator = 0
    instructions.each { |instruction| instruction[:visited] = false }
    run_line(0)
  end

  def recover
    { status: :failed, type: :no_corruption } if execute[:status] == :successful
    report = { status: :failed, type: :no_corruption_fixed }
    instructions.each.with_index do |instruction, line|
      if instruction[:type] == :nop && instruction[:value] != 0 && fix_nop?(instruction)
        report = { status: :successful, type: :nop, line: line + 1 }
        break
      elsif instruction[:type] == :jmp && fix_jmp?(instruction)
        report = { status: :successful, type: :jmp, line: line + 1 }
        break
      end
    end
    report
  end

  def apply_patch(patch)
    instructions[patch[:line] - 1][:type] = patch[:type] == :nop ? :jmp : :nop
  end

  private


  def generate_byte_code(code)
    splitted_code = code.split(' ')
    { type: splitted_code.first.to_sym, value: splitted_code.last.to_i, visited: false }
  end

  def run_line(pointer)
    return { status: :successful, value: accumulator} if pointer >= instructions.count

    instruction = instructions[pointer]
    return { error: :infinite_loop, line: pointer + 1 } if instruction[:visited]

    instruction[:visited] = true

    run_line(pointer + @handlers[instruction[:type]].call(instruction[:value]).to_i)
  end

  def nop(_)
    1
  end

  def acc(value)
    @accumulator += value
    1
  end

  def jmp(value)
    value
  end

  def fix_nop?(instruction)
    sandbox_edit_and_run do
      instruction[:type] = :jmp
    end[:status] == :successful
  end

  def fix_jmp?(instruction)
    sandbox_edit_and_run do
      instruction[:type] = :nop
    end[:status] == :successful
  end

  def sandbox_edit_and_run
    initial_instructions = instructions.map(&:dup)
    yield if block_given?
    execute.tap do
      @instructions.each.with_index { |_, idx| @instructions[idx][:type] = initial_instructions[idx][:type] }
    end
  end
end
