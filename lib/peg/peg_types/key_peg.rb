# represents a key peg that can be placed on the feedback portion of the board
class KeyPeg
  FULL_MATCH_COLOR = "full".freeze
  POSITION_MATCH_COLOR = "pos".freeze
  COLOR_OPTIONS = [FULL_MATCH_COLOR, POSITION_MATCH_COLOR].freeze

  private_class_method :new
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def self.full_match
    new(FULL_MATCH_COLOR)
  end

  def self.position_match
    new(POSITION_MATCH_COLOR)
  end

  def to_s
    color
  end

  def full_match?
    color == FULL_MATCH_COLOR
  end

  def self.random_color
    COLOR_OPTIONS.sample
  end

  def position_match?
    color == POSITION_MATCH_COLOR
  end
end
