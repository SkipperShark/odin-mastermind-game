require_relative "peg_types/key_peg"

# represents a set of key pegs, which represent a clue
class KeyPegSet < PegSet
  def initialize # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def add_to_set(color)
    return if complete?

    pegs[pegs.index nil] = KeyPeg.new(color)
  end
end
