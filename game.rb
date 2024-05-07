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


class Game
  def initialize
    @human = Player.new(is_codemaker: false, is_human: true)
    @computer = Player.new(is_codemaker: true, is_human: false)
    @board = Board.new
    introduction
    # @board.show
    pp @human.code
    pp @computer.code
  end

  def introduction
    puts "Welcome to mastermind.\n"
  end

end


class Player

  attr_reader :code

  #4 cases
  # human codebreaker (do nothing)
  # human codemaker (ask for pattern)
  # computer codebreaker (do nothing)
  # computer codemaker (generate pattern)

  def initialize(is_codemaker:, is_human:)

    @code = nil unless is_codemaker

    if is_human
      prompt_secret_pattern
    else
      get_random_secret_pattern
    end

  end

  def prompt_secret_pattern
    #todo implementation pending
  end

  def get_random_secret_pattern
    @code = Array.new(4) { CodePeg.new(CodePeg.get_random_color)}
  end

  private

  attr_writer :code

end
