# frozen_string_literal: true

# represents a key peg that can be placed on the feedback portion of the board
class KeyPeg
  FULL_MATCH_COLOR = "red"
  POSITION_MATCH_COLOR = "white"
  COLOR_OPTIONS = [FULL_MATCH_COLOR, POSITION_MATCH_COLOR].freeze

  private_class_method :new
  attr_reader :color

  def initialize(color_option)
    @color = color_option
  end

  def self.full_match
    self.new(FULL_MATCH_COLOR)
  end

  def self.position_match
    self.new(POSITION_MATCH_COLOR)
  end

  def to_s
    color
  end

  def full_match?
    if color == FULL_MATCH_COLOR
      true
    else
      false
    end
  end

  def self.random_color
    COLOR_OPTIONS.sample
  end

  def position_match?
    if color == POSITION_MATCH_COLOR
      true
    else
      false
    end
  end
end
