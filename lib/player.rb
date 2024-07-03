require_relative "utilites"
require_relative "code_peg"

# Represents a player, which can either be a codemaker or a codebreaker
# Players can be human or computer
class Player
  include Utilities
  attr_accessor :secret, :guess
  attr_reader :is_codemaker, :is_human

  # 4 cases
  # human codebreaker (do nothing)
  # human codemaker (ask for pattern)
  # computer codebreaker (do nothing)
  # computer codemaker (generate pattern)

  def initialize(is_codemaker:, is_human:)
    @is_codemaker = is_codemaker
    @is_human = is_human
    # super()
    if is_codemaker
      @secret = []
      if is_human

        #info just to make my life easier
        # @secret <<  CodePeg.new("red")
        # @secret <<  CodePeg.new("green")
        # @secret <<  CodePeg.new("blue")
        # @secret <<  CodePeg.new("yellow")

        build_secret_pattern

      else
        generate_secret_pattern
      end
    else
      @guess = []
    end
  end

  # def self.codebreaker(is_human)
  #   new(is_codemaker: false, is_human:)
  # end

  def self.codemaker(is_human)
    new(is_codemaker: true, is_human:)
  end

  def show_secret
    secret.map(&:to_s)
  end

  # def build_guess_pattern
  #   puts 'Input color for first guess of your guess pattern. Enter "r" to start again'
  #   until pattern_complete? guess
  #     puts "your guesses : #{guess.map { |ele| ele.color}}"
  #     input = user_input
  #     if input == "r"
  #       reset_guess
  #       next
  #     end
  #     unless valid_user_input? input
  #       puts "That is not a valid color! Please try again"
  #       next
  #     end
  #     self.guess << CodePeg.new(input)
  #   end
  #   puts "final guess pattern : #{guess.map { |ele| ele.color}}"
  # end

  # def user_confirmed?
  #   valid_choice = false
  #   until valid_choice == true
  #     puts "guess pattern complete, would you like to confirm? (y/n)"
  #     input = user_input
  #     if input == "y"
  #       return true
  #     elsif input == "n"
  #       return false
  #     else
  #       puts "I'm not sure what you mean, please try again"
  #     end
  #   end
  # end

  # def reset_guess
  #   guess.clear
  # end

  # def guess_complete?
  #   pattern_complete? guess
  # end

  private

    def prompt_secret_pattern
      puts 'Input color for first secret of your secret pattern. Enter "r" to start again'
      until pattern_complete? secret
        puts "your secret : #{secret.map { |ele| ele.color}}"
        input = user_input
        if input == "r"
          reset_secret
          next
        end
        unless valid_user_input? input
          puts "That is not a valid color! Please try again"
          next
        end
        self.secret << CodePeg.new(input)
      end
      puts "final secret pattern : #{secret.map { |ele| ele.color}}"
    end

    def build_secret_pattern
      secret_done = false
      until secret_done == true
        prompt_secret_pattern
        if user_confirmed?
          secret_done = true
          break
        end
        reset_secret
      end
    end

    def reset_secret
      secret.clear
    end

    def generate_secret_pattern
      self.secret = Array.new(4) { CodePeg.random_color }
    end

    # def valid_user_input?(user_input)
    #   begin
    #     CodePeg.new user_input
    #     true
    #   rescue ArgumentError
    #     false
    #   end
    # end

    def pattern_complete?(pattern)
      pattern.length == 4
    end

end
