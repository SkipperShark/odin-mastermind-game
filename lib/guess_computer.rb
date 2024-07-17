require "colorize"
require_relative "peg/peg_types/code_peg"
require_relative "peg/code_peg_set"
require_relative "clue_computer"

# represents an algorithm that, based on clues given by the game engine,
# constructs guesses to try to win the game. used when the codebreaker is
# the computer
class GuessComputer
  def initialize
    @code_color_options = CodePeg.color_options
    @guess_options = compute_guess_options
    @guess_options_static = @guess_options.dup

    @current_option = nil
    @guess_history = []

    @color_counter = 1
    @solution = []

    # show_guess_history
  end

  def compute
    first_turn = guess_history.empty?
    self.current_option = if first_turn
                            guess_options.select { |option| option[:id] == "1122" }.first
                          else
                            guess_options.first
                          end

    guess = construct_guess(current_option[:colors])
    puts "guess : #{guess}".colorize(:cyan)
    guess
  end

  def calc_response(clue)
    # puts "calc response"
    # puts "current_option : #{current_option}".colorize(:cyan)
    # puts "clue : #{clue}".colorize(:cyan)
    num_position_matches = clue.pegs.count { |key_peg| key_peg&.position_match? }
    num_full_matches = clue.pegs.count { |key_peg| key_peg&.full_match? }
    # puts "guess options length : #{guess_options.length}"

    guess_options.filter! do |option|
      sim_secret = construct_guess(option[:colors])
      sim_guess = construct_guess(current_option[:colors])
      clue_computer = ClueComputer.new(sim_guess, sim_secret)
      sim_clue = clue_computer.compute
      s_num_pos_matches = sim_clue.pegs.count { |peg| peg&.position_match? }
      s_num_full_matches = sim_clue.pegs.count { |peg| peg&.full_match? }
      delete_guess =  num_position_matches != s_num_pos_matches ||
                      num_full_matches != s_num_full_matches
      option unless delete_guess
    end

    add_to_guess_history
    show_guess_options
    puts "End of turn. Guess history:".colorize(:cyan)
    show_guess_history
  end

  private

  attr_accessor :guess_options, :current_option, :guess_history,
                :guess_options_static, :color_counter, :solution
  attr_reader :code_color_options

  def construct_guess(colors)
    CodePegSet.from_colors(colors)
  end

  def add_to_guess_history
    guess_history << {
      colors: current_option[:colors],
      score: guess_options.size,
      options: guess_options
    }
  end

  def show_guess_options
    pp guess_options
  end

  def show_guess_history
    guess_history.each do |guess|
      pp "colors: #{guess[:colors]}, score: #{guess[:score]}"
    end
  end

  def compute_guess_options
    options = code_color_options.each.with_index(1).map do |color, index|
      {
        color:,
        code: index
      }
    end
    raw = options.repeated_permutation(4).to_a
    raw.each_with_index.map do |guess, index|
      {
        index:,
        id: guess.map { |code_peg| code_peg[:code] }.join,
        colors: guess.map { |code_peg| code_peg[:color] }
      }
    end
  end
end
