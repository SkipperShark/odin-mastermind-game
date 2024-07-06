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
    pegs.all?(&:full_match?)
  end

  private

  def add_to_set(color)
    return if complete?

    pegs[pegs.index nil] = KeyPeg.new(color)
  end
end
