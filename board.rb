# frozen_string_literal: true

# represents the mastermind board
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(12) { [1, 2, 3, 4] }
  end

  def show
    @board.each do |row|
      pp row
    end
  end
end


# represents a code peg that can be placed on the board, a code peg can be of various colours
class CodePeg
  @@color_options = %w[red green purple yellow brown orange black white]

  def initialize(color_option)
    unless @@color_options.include?(color_option)
      puts 'that is not a valid colour option!'
      return
    end
    @color_option = color_option
  end

  def self.get_random_color
    @@color_options.sample
  end
end
