# frozen_string_literal: true

# represents the mastermind board
class Board
  attr_accessor :board

  def initialize
    @board = {
      code_rows: [],
      decode_rows: []
    }
    add_code_rows
    add_decode_rows
  end

  def show(row_to_indicate = nil)
    puts "Code Pegs\t\t\t\t\t\tKey Pegs"
    p @board[:code_rows]
    @board[:decode_rows].each do |row|
      puts "#{row[:code_pegs].map(&:to_s)}\t\t\t\t|\t#{row[:key_pegs].map(&:to_s)}"
    end
  end

  def add_guess(guess_pattern, clue_pattern)
    row_index = @board[:decode_rows].rindex { |row| row[:code_pegs].all?("") }
    return if row_index.nil?
    @board[:decode_rows][row_index][:code_pegs] = guess_pattern

    clue_pattern.each_index do |i|
      @board[:decode_rows][row_index][:key_pegs][i] = clue_pattern[i]
    end

  end

  private

  def add_code_rows
    @board[:code_rows] = ['?', '?', '?', '?']
  end

  def add_decode_rows
    # decode_row = {
    #   code_pegs:  ['', '', '', ''],
    #   # is_code: false,
    #   key_pegs: ['','','','','']
    # }
    # @board[:decode_rows] = Array.new(12) {decode_row}
    # @board[:decode_rows] = Array.new(12) do
    #   decode_row = {
    #     code_pegs:  ['', '', '', ''],
    #     # is_code: false,
    #     key_pegs: ['','','','','']
    #   }
    #   decode_row
    # end
    @board[:decode_rows] = Array.new(12) {{
        code_pegs:  ['', '', '', ''],
        # is_code: false,
        key_pegs: ['','','','']
      }}
  end

end

# represents a code peg that can be placed on the board, a code peg can be of various colours
class CodePeg
  COLOR_OPTIONS = %w[red green blue yellow brown orange black white].freeze
  attr_reader :color

  def initialize(color_option)
    unless COLOR_OPTIONS.include?(color_option)
      raise ArgumentError.new("Invalid code peg color option ")
    end
    @color = color_option
  end

  def self.random_color
    COLOR_OPTIONS.sample
  end

  def to_s
    color
  end
end

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

  def position_match?
    if color == POSITION_MATCH_COLOR
      true
    else
      false
    end
  end

end

class Game

  def initialize
    @human = Player.new(is_codemaker: false, is_human: true)
    @computer = Player.new(is_codemaker: true, is_human: false)
    @board = Board.new
    @game_ended = false
    @turn = 1

    @codemaker = @computer
    @codebreaker = @human

    @guess = []
    @clue = []

    puts "secret code : #{@computer.debug_get_code}"
  end

  def introduction
    puts "Welcome to mastermind\n\n"
    puts "these are the color options : #{CodePeg::COLOR_OPTIONS}\n"
    # @board.show
    print "\n"
  end

  def play
    until game_ended
      board.show
      puts "turn : #{turn}"
      build_guess_pattern
      unless user_confirmed_guess
        reset_guess
        next
      end
      compare_guess_to_secret
      update_board
      self.game_ended = true if codebreaker_won?
      next_turn
    end
    board.show
    puts "game ended, thanks for playing"
  end

  private

  attr_accessor :game_ended, :guess, :turn, :clue, :board
  attr_reader :codemaker, :codebreaker

  def next_turn
    self.clue = []
    self.guess = []
    self.turn += 1
  end

  def update_board
    board.add_guess(guess, clue)
  end

  def codebreaker_won?
    clue.count { |key_peg| key_peg.full_match? } >= 4
  end

  def compare_guess_to_secret
    secret_pattern = codemaker.code.clone.map(&:to_s)
    guess_pattern = guess.clone.map(&:to_s)

    # find color and position matches
    guess_pattern.each.with_index do |guess_color, i|
      secret_pattern.each.with_index do |secret_color, y|
        if guess_color == secret_color and i == y
          self.clue << KeyPeg.full_match
          guess_pattern[i] = nil
          secret_pattern[y] = nil
          break
        end
      end
    end
    guess_pattern.compact!
    secret_pattern.compact!

    # find position matches only
    guess_pattern.each.with_index do |guess_color, i|
      secret_pattern.each.with_index do |secret_color, y|
        if guess_color == secret_color
          self.clue << KeyPeg.position_match
          guess_pattern[i] = nil
          secret_pattern[y] = nil
          break
        end
      end
    end

    guess_pattern.compact!
    secret_pattern.compact!

    # puts "\n\nafter first iteration \n\n"
    # puts "secret_pattern : #{secret_pattern}"
    # puts "guess_pattern : #{guess_pattern}"
    # puts "clue : #{clue}"

  end

  def user_confirmed_guess
    valid_choice = false
    until valid_choice == true
      puts "guess pattern complete, would you like to confirm? (y/n)"
      input = user_input
      if input == "y"
        return true
      elsif input == "n"
        return false
      else
        puts "I'm not sure what you mean, please try again"
      end
    end
  end

  def build_guess_pattern
    puts 'Input color for first guess of your guess pattern. Enter "r" to start again'
    until guess_complete
      puts "your guesses : #{guess.map { |ele| ele.color}}"
      input = user_input
      if input == "r"
        self.guess = []
        next
      end
      unless valid_user_input? input
        puts "That is not a valid color! Please try again"
        next
      end
      self.guess << CodePeg.new(input)
    end
    puts "final guess pattern : #{guess.map { |ele| ele.color}}"
  end

  def user_input
    gets.chomp.downcase.lstrip.rstrip
  end

  def valid_user_input?(user_input)
    begin
      CodePeg.new user_input
      true
    rescue ArgumentError
      false
    end
  end

  def guess_complete
    @guess.length == 4
  end

  def reset_guess
    @guess.clear
  end
end

class Player
  # attr_reader :code
  attr_accessor :code

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

  # attr_writer :code
end
