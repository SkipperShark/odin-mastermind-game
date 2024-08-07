require_relative "peg/code_peg_set"
require_relative "peg/key_peg_set"

# represents the mastermind board, which includes guess rows and clue rows
class Board
  attr_accessor :board_rows

  def initialize
    @board_rows = Array.new(12) do
      {
        guess: CodePegSet.new,
        clue: KeyPegSet.new
      }
    end
  end

  def show
    puts "Guesses\t\t\t\t\t\t\tClues"
    @board_rows.each do |row|
      row[:guess].display
      print "\t\t\t\t|\t\t"
      row[:clue].display
      puts ""
    end
  end

  def add_solve_attempt(guess, clue)
    row_index = board_rows.rindex { |row| row[:guess].not_complete? }
    return if row_index.nil?

    board_rows[row_index][:guess] = guess.dup
    board_rows[row_index][:clue] = clue.dup
  end
end
