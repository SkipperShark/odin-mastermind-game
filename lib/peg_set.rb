# represents a set of pegs, which may either be code pegs or key pegs
class PegSet
  include Utilities

  attr_accessor :pegs

  def initialize
    @pegs = empty
  end

  def display
    @pegs.map do |peg|
      print peg.nil? ? "_ " : "#{peg} "
    end
  end

  def reset
    self.code_pegs = empty
  end

  def complete?
    @pegs.all? { |code_peg| !code_peg.nil? }
  end

  private

  def empty
    [nil, nil, nil, nil]
  end

  def display_current_set
    print "Your set : "
    display
    puts ""
  end
end
