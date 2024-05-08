# frozen_string_literal: true

# represents the mastermind board
class Board
  attr_accessor :board

  def initialize
    @board = []
    create_code_row
    create_decode_rows
    # @board = Array.new(12) { [1, 2, 3, 4] }
  end

  def show
    @board.each do |row|
      pp row
    end
  end

  def create_code_row
    @board.prepend ['?', '?', '?', '?']
  end

  def create_decode_rows
    @board += Array.new(12) { [1, 2, 3, 4] }
  end
end

# represents a code peg that can be placed on the board, a code peg can be of various colours
class CodePeg
  COLOR_OPTIONS = %w[red green purple yellow brown orange black white].freeze
  attr_reader :color

  def initialize(color_option)
    unless COLOR_OPTIONS.include?(color_option)
      puts 'that is not a valid colour option!'
      return
    end
    @color = color_option
  end

  def self.get_random_color
    COLOR_OPTIONS.sample
  end
end

class Game

  attr_accessor :game_ended

  def initialize
    @human = Player.new(is_codemaker: false, is_human: true)
    @computer = Player.new(is_codemaker: true, is_human: false)
    @board = Board.new
    @game_ended = false
    @current_row = 0

    puts "secret code : #{@computer.debug_get_code}"
  end

  def introduction
    puts "Welcome to mastermind\nThis is the board\n\n"
    @board.show
    print "\n"
  end

  def play
    until @game_ended
      user_input = gets.chomp

      puts "user input : #{user_input}"

      unless valid_user_input?(user_input)
        puts "That is not a valid color! Please try again"
        next
      end



    end
  end

  def valid_user_input?(user_input)
    CodePeg::COLOR_OPTIONS.include? user_input
  end
end

class Player
  attr_reader :code

  # 4 cases
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
    # TODO: implementation pending
  end

  def get_random_secret_pattern
    @code = Array.new(4) { CodePeg.new(CodePeg.get_random_color) }
  end

  def debug_get_code
    @code.map(&:color)
  end

  private

  attr_writer :code
end
