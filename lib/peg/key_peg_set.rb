require_relative "peg_types/key_peg"
require_relative "peg_set"

# represents a set of key pegs, which represent a clue
class KeyPegSet < PegSet
  def initialize # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def add_position_match
    add_to_set(KeyPeg.position_match)
  end

  def add_full_match
    add_to_set(KeyPeg.full_match)
  end

  def all_full_matches?
    pegs.all? do |key_peg|
      puts "key peg inspect : #{key_peg.inspect}"
      puts "key peg color : #{key_peg.color}"
      puts "key peg color object id : #{key_peg.color.object_id}"
      puts "key peg color class : #{key_peg.color.class}"
      puts "key peg FULL_MATCH_COLOR : #{key_peg.FULL_MATCH_COLOR}"
      puts "key peg FULL_MATCH_COLOR object id : #{key_peg.FULL_MATCH_COLOR.object_id}"
      puts "key peg FULL_MATCH_COLOR class : #{key_peg.FULL_MATCH_COLOR.class}"
      puts "key_peg.FULL_MATCH_COLOR == key_peg.color : #{key_peg.FULL_MATCH_COLOR == key_peg.color}"
      puts "key_peg full match? : #{key_peg.full_match?}"
      key_peg.full_match?
    end
    # pegs.all?(&:full_match?)
  end

  private

  def add_to_set(key_peg)
    return if complete?

    pegs[pegs.index nil] = key_peg
  end
end
