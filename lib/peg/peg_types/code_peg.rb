# represents a code peg that can be placed on the board,
# a code peg can be of various colours defined in the color options constant
class CodePeg
  # COLOR_OPTIONS = %w[red green blue yellow brown orange black white].freeze
  COLOR_OPTIONS = %w[red green blue yellow black white].freeze
  attr_reader :color

  def initialize(color)
    invalid_color_error unless COLOR_OPTIONS.include?(color)
    @color = color
  end

  def self.random_color
    COLOR_OPTIONS.sample
  end

  def self.color_options
    COLOR_OPTIONS
  end

  def self.valid_color?(color)
    CodePeg.new color
    true
  rescue ArgumentError
    false
  end

  def to_s
    color
  end

  private

  def invalid_color_error
    raise ArgumentError, "Invalid code peg color option"
  end
end
