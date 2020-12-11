class Group
  attr_reader :unique_answers
  attr_reader :answers

  def initialize
    @unique_answers = []
    @answers = []
  end

  def add_answers(answers)
    @unique_answers = (@unique_answers + answers.chomp.split('')).uniq
    @answers << answers.chomp.split('')
  end

  def unanimous_answers
    @unique_answers.select do |answer|
      @answers.reject { |answer_list| answer_list.include?(answer) }.empty?
    end
  end
end
