require_relative "peg/key_peg_set"

# Computes clues from a guess and a secret
class Clue
  def initialize(guess, secret)
    @guess = guess.dup
    @secret = secret.dup
    @clue = KeyPegSet.new.map do |key_peg|
      key_peg.is_matched = false
    end
    compute
  end

  def compute
    determine_full_matches_v2
    guess.compact!
    secret.compact!
    # find color and position matches
    # guess_pattern.each.with_index do |guess_code_peg, i|
    #   secret_pattern.each.with_index do |secret_code_peg, y|
    #     color_matched = guess_code_peg.color == secret_code_peg.color
    #     position_matched = (i == y)
    #     not_previously_matched = !secret_code_peg.nil?
    #     if color_matched && position_matched && not_previously_matched
    #       clue.add_full_match
    #       guess_pattern[i] = nil
    #       secret_pattern[y] = nil
    #       break
    #     end
    #   end
    # end
    # guess_pattern.compact!
    # secret_pattern.compact!

    #? use #intersection for position match?
    # find position matches only
    guess_pattern.each.with_index do |guess_color, i|
      secret_pattern.each.with_index do |secret_code_peg, y|
        if guess_color == secret_code_peg
          clue << KeyPeg.position_match
          guess_pattern[i] = nil
          secret_pattern[y] = nil
          break
        end
      end
    end

    guess_pattern.compact!
    secret_pattern.compact!
    clue
  end

  private

  attr_accessor :clue
  attr_reader :guess, :secret

  # def determine_full_matches_v1
  #   secret_pattern = secret.each_with_index.map.with do |code_peg, index|
  #     {
  #       peg: code_peg,
  #       index:
  #     }
  #   end
  #   guess_pattern = guess.each_with_index.map.with do |code_peg, index|
  #     {
  #       peg: code_peg,
  #       index:
  #     }
  #   end

  #   # find color and position matches
  #   guess_pattern.each do |guess_ele|
  #     secret_pattern.each do |secret_ele|
  #       color_matched = guess_ele[:peg].color == secret_ele[:peg].color
  #       position_matched = (guess_ele[:index] == secret_ele[:index])
  #       not_previously_matched = !secret_code_peg.nil?
  #       next unless color_matched && position_matched && not_previously_matched

  #       clue.add_full_match
  #       guess_pattern[i] = nil
  #       secret_pattern[y] = nil
  #       break
  #     end
  #   end
  #   guess_pattern.compact!
  #   secret_pattern.compact!
  # end

  # find color and position matches
  def determine_full_matches_v2
    guess.each_with_index do |guess_peg, index|
      secret_peg = secret[index]
      next unless guess_peg.color == secret_peg.color

      clue.add_full_match
      guess[index] = nil
      secret[index] = nil
    end
    # guess_pattern.compact!
    # secret_pattern.compact!
  end
end
