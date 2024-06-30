# Represents a row on the board containing code peg guesses
class Guess
  def initialize
    @code_pegs = [nil, nil, nil, nil]
  end

  def display
    # return if no_code_pegs

    @code_pegs.map do |code_peg|
      print code_peg.nil? ? "_ " : "#{code_peg} "
    end
  end

  # private

  # def no_code_pegs
  #   @code_pegs.all?(&:nil?)
  # end
end
