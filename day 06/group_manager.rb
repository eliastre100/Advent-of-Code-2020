class GroupManager
  attr_reader :groups

  def initialize
    @groups = [Group.new]
  end

  def add_answers(answers)
    if answers.strip == ''
      @groups << Group.new
    else
      @groups.last.add_answers(answers)
    end
  end
end
