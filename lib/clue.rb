# represents a row on the board representing key peg clues
class Clue
  def initialize
    @key_pegs = [nil, nil, nil, nil]
  end

  def display
    # return if no_key_pegs

    @key_pegs.map do |code_peg|
      print code_peg.nil? ? "_ " : "#{code_peg} "
    end
  end

  # private

  # def no_key_pegs
  #   @key_pegs.all?(&:nil?)
  # end
end
