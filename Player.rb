# frozen_string_literal: true

require_relative 'Utilities'
require_relative 'CodePeg'


class Player < Utilities
  # attr_reader :code
  attr_accessor :code

  # 4 cases
  # human codebreaker (do nothing)
  # human codemaker (ask for pattern)
  # computer codebreaker (do nothing)
  # computer codemaker (generate pattern)

  def initialize(is_codemaker:, is_human:)
    super()
    if is_codemaker
      @code = []
    else
      @guess = []
    end

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

  def build_guess_pattern
    puts 'Input color for first guess of your guess pattern. Enter "r" to start again'
    guess = []
    until guess.length == 4
      puts "your guesses : #{guess.map { |ele| ele.color}}"
      input = user_input
      if input == "r"
        guess = []
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

  private

  def valid_user_input?(user_input)
    begin
      CodePeg.new user_input
      true
    rescue ArgumentError
      false
    end
  end

  def reset_guess
    @guess.clear
  end

  # def guess_complete
  #   @guess.length == 4
  # end

  # attr_writer :code
end
