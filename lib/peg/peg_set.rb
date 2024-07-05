require_relative "../utilites"

# represents a set of pegs, which may either be code pegs or key pegs
class PegSet
  include Utilities

  attr_accessor :pegs

  def initialize
    @pegs = empty
  end

  def to_s
    @pegs.map { |peg| peg.nil? ? "_ " : "#{peg.color} " }.join
  end

  def reset
    self.pegs = empty
  end

  def complete?
    @pegs.all? { |code_peg| !code_peg.nil? }
  end

  def not_complete?
    !complete?
  end

  private

  def empty
    [nil, nil, nil, nil]
  end

  def display_current_set
    puts "Your set : #{self}"
  end
end
