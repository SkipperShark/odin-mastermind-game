# represents a code peg that can be placed on the board, a code peg can be of various colours
class CodePeg
  # COLOR_OPTIONS = %w[red green blue yellow brown orange black white].freeze
  COLOR_OPTIONS = %w[red green blue yellow black white].freeze
  attr_reader :color

  def initialize(color_option)
    valid_option = COLOR_OPTIONS.include?(color_option)
    raise ArgumentError, "Invalid code peg color option " unless valid_option

    @color = color_option
  end

  def self.random_color
    COLOR_OPTIONS.sample
  end

  def self.color_options
    COLOR_OPTIONS
  end

  def to_s
    color
  end
end
