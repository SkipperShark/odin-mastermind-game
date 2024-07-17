require_relative "peg/key_peg_set"

# Computes clues from a guess and a secret
class ClueComputer
  attr_reader :clue_pegs

  def initialize(guess, secret)
    @guess = guess
    @secret = secret
    @guess_pegs = guess.pegs.dup
    @secret_pegs = secret.pegs.dup
    @clue_pegs = KeyPegSet.new
  end

  def compute
    determine_full_matches
    guess_pegs.compact!
    secret_pegs.compact!
    determine_position_matches
    clue_pegs
  end

  private

  attr_writer :clue_pegs
  attr_reader :guess, :secret, :guess_pegs, :secret_pegs

  def determine_full_matches
    guess_pegs.each_with_index do |guess_peg, index|
      secret_peg = secret_pegs[index]
      next unless guess_peg.color == secret_peg.color

      clue_pegs.add_full_match
      guess_pegs[index] = nil
      secret_pegs[index] = nil
    end
  end

  def determine_position_matches
    secret_peg_colors = secret_pegs.map(&:color)

    guess_pegs.each_with_index do |guess_peg, index|
      next if guess_peg.nil?

      pos_match_found = secret_peg_colors.index guess_peg.color
      next unless pos_match_found

      clue_pegs.add_position_match
      guess_pegs[index] = nil
      secret_pegs[index] = nil
    end
  end
end
