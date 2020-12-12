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
    instructions.each { |instruction| instruction[:visited] = false }
    run_line(0)
  end
  
  private

  HANDLERS =
  
  def generate_byte_code(code)
    splitted_code = code.split(' ')
    { type: splitted_code.first.to_sym, value: splitted_code.last.to_i, visited: false }
  end

  def run_line(pointer)
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
end
