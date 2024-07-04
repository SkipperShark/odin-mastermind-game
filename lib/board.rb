require_relative "peg/code_peg_set"
require_relative "peg/key_peg_set"

# represents the mastermind board, which includes guess rows and clue rows
class Board
  attr_accessor :board

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
    @board_rows.each { |row| display row}
  end

  # #todo to be refactored
  # def add_guess(guess_pattern, clue_pattern)
  #   # puts "guess_pattern : #{guess_pattern}"
  #   row_index = self.board[:decode_rows].rindex { |row| row[:code_pegs].all?("") }
  #   # puts "row_index : #{row_index}}"
  #   return if row_index.nil?
  #   self.board[:decode_rows][row_index][:code_pegs] = guess_pattern.clone

  #   clue_pattern.each_index do |i|
  #     self.board[:decode_rows][row_index][:key_pegs][i] = clue_pattern[i]
  #   end
  # end

  private

  def display(row)
    row[:guess].display
    print "\t\t\t\t|\t"
    row[:clue].display
    puts ""
  end
end
