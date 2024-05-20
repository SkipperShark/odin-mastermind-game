# frozen_string_literal: true

require_relative 'Utilities'
require_relative 'CodePeg'


class Player < Utilities
  # attr_reader :code
  attr_accessor :code, :guess

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


  def debug_get_code
    code.map(&:color)
  end

  def build_guess_pattern
    puts 'Input color for first guess of your guess pattern. Enter "r" to start again'
    until guess.length == 4
      puts "your guesses : #{guess.map { |ele| ele.color}}"
      input = user_input
      if input == "r"
        reset_guess
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

  def reset_guess
    guess.clear
  end

  private

    def get_random_secret_pattern
      self.code = Array.new(4) { CodePeg.new(CodePeg.random_color) }
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
      guess.length == 4
    end

end
