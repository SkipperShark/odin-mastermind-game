require_relative 'CodePeg'

class Solver
  attr_accessor :clue, :guess

  def initialize
    @clue = []
    @guess = []
  end

  def derive_guess(turn)
    puts "derive guess, clue : #{clue}"
    first_turn = turn == 1 ? true : false
    if first_turn
        4.times do
            guess << CodePeg.new(CodePeg::COLOR_OPTIONS.first)
        end
        return guess
    end

    4.times do
      guess << CodePeg.new(CodePeg::COLOR_OPTIONS.last)
    end
    return guess

  end

  def update_clue(clue)
    self.clue = clue
  end
end
