# frozen_string_literal: true

require_relative 'board'

#plan
#create the board
#define the colors a peg can be
#generate the secret pattern of pegs for the codebreaker to guess
#get inputs from user
#instructions to the user on how to play can be done later
#translate user input into a color and position a peg of said onto the board
#allow the user to replace placed pegs
#validation to ensure all spaces on a row are placed with pegs
#provide a button for the codebreaker to check placed pegs against the secret pattern
#logic to compare placed pegs against secret pattern
#place key pags onto feedback portion of the board

board = Board.new
board.show

test = CodePeg.new(CodePeg.get_random_color)
pp test
