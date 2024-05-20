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

  def show
    puts "Code Pegs\t\t\t\t\t\tKey Pegs"
    p @board[:code_rows]
    @board[:decode_rows].each do |row|
      puts "#{row[:code_pegs].map(&:to_s)}\t\t\t\t|\t#{row[:key_pegs].map(&:to_s)}"
    end
  end

  def add_guess(guess_pattern, clue_pattern)
    puts "guess_pattern : #{guess_pattern}"
    row_index = self.board[:decode_rows].rindex { |row| row[:code_pegs].all?("") }
    puts "row_index : #{row_index}}"
    return if row_index.nil?
    self.board[:decode_rows][row_index][:code_pegs] = guess_pattern.clone

    clue_pattern.each_index do |i|
      self.board[:decode_rows][row_index][:key_pegs][i] = clue_pattern[i]
    end
  end

  private

    def add_code_rows
      @board[:code_rows] = ['?', '?', '?', '?']
    end

    def add_decode_rows
      @board[:decode_rows] = Array.new(12) {{
          code_pegs:  ['', '', '', ''],
          # is_code: false,
          key_pegs: ['','','','']
        }}
    end

end
