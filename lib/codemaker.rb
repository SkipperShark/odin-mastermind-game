require_relative "code_peg_set"

# Represents a player that is the codemaker, contains logic and methods that
# describe what the codemaker can do, such as setting the secret code
class Codemaker
  include Utilities

  attr_reader :is_human

  def initialize(is_human)
    @is_human = is_human
    @secret = CodePegSet.new
  end
end
