# frozen_string_literal: true

require_relative 'game'

#* plan
# create the board
# define the colors a peg can be
# generate the secret pattern of pegs for the codebreaker to guess
# get inputs from user
#* instructions to the user on how to play can be done later
# translate user input into a color and position a peg of said onto the board
# allow the user to replace placed pegs
# validation to ensure all spaces on a row are placed with pegs
# provide a way for the codebreaker to check placed pegs against the secret pattern
# logic to compare placed pegs against secret pattern
#* place key pegs onto feedback portion of the board
#* place code pegs on code portion of the board
#* check if user guess all correct
#* check game end condition
#* if game did not end, move on to next row
#* repeat until end
#* if codebreaker has not guess right pattern at the end, end the game

# enhancement
# show which row we are on right now

game = Game.new
game.introduction
game.play
