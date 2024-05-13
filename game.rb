# frozen_string_literal: true

# represents the mastermind board
class Board
  attr_accessor :board

  def initialize
    @board = []
    create_code_row
    create_decode_rows
  end

  def show
    puts "Code Pegs\t\t\t\t\t\tKey Pegs"
    @board.each do |row|
      puts "#{row[:code_pegs]}\t\t\t\t|\t#{row[:key_pegs] == nil ? "" : row[:key_pegs]}"
    end
  end

  def create_code_row
    code_row = {
      code_pegs:  ['?', '?', '?', '?'],
      is_code: true,
      key_pegs: nil
    }
    @board.prepend code_row
  end

  def create_decode_rows
    decode_row = {
      code_pegs:  ['', '', '', ''],
      is_code: false,
      key_pegs: ['','','','','']
    }
    12.times do
      @board << decode_row
    end
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

  def self.random_color
    COLOR_OPTIONS.sample
  end
end

class Game

  attr_accessor :game_ended, :guess

  def initialize
    @human = Player.new(is_codemaker: false, is_human: true)
    @computer = Player.new(is_codemaker: true, is_human: false)
    @board = Board.new
    @game_ended = false
    @turn = 0

    @codemaker = @computer
    @codebreaker = @human

    @guess = []

    puts "secret code : #{@computer.debug_get_code}"
  end

  def introduction
    puts "Welcome to mastermind\nThis is the board\n\n"
    @board.show
    print "\n"
    puts "these are the color options : #{CodePeg::COLOR_OPTIONS}\n"
  end

  def play
    until @game_ended
      build_guess_pattern
      if user_confirmed_guess
        compare_guess_to_secret
        break
      else
        reset_guess
        next
      end
    end
  end

  private

  def compare_guess_to_secret
    puts "start compare_guess_to_secret"
    #* same position and color
    clue = []
    secret = @codemaker.code.clone
    guess = @guess
    puts "secret : #{secret}, guess : #{guess}"
    @guess.each.with_index do |code_color, i|
      puts ""
      # if secret.include?(code_color) &&

      # secret_color = @guess[i]
      # if code_color == secret_color
      #   clue.append("red")
      # end

    end

    #* same
  end

  def user_confirmed_guess
    puts "guess pattern complete, would you like to confirm? (y/n)"
    valid_choice = false
    until valid_choice == true
      input = user_input
      if input == "y"
        return true
      elsif input == "n"
        return false
      else
        "I'm not sure what you mean, please try again"
      end
    end
  end

  def build_guess_pattern
    puts "Input color for first guess of your guess pattern"
    until guess_complete
      input = user_input
      unless valid_user_input? input
        puts "That is not a valid color! Please try again"
        next
      end
      add_color_to_guess input
      puts "your guess : #{guess}"
    end
  end

  def user_input
    gets.chomp.downcase
  end

  def valid_user_input?(user_input)
    CodePeg::COLOR_OPTIONS.include? user_input
  end

  def add_color_to_guess(color)
    @guess << color
  end

  def guess_complete
    @guess.length == 4
  end

  def reset_guess
    @guess.clear
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
    @code = Array.new(4) { CodePeg.new(CodePeg.random_color) }
  end

  def debug_get_code
    @code.map(&:color)
  end

  private

  attr_writer :code
end
