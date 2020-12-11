class Group
  attr_reader :answers

  def initialize
    @answers = []
  end

  def add_answers(answers)
    @answers = (@answers + answers.chomp.split('')).uniq
  end

  def number_answers
    @answers.count
  end
end
