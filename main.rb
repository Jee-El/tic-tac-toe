# frozen_string_literal: true

require './tic_tac_toe'

def start_game
  game = TicTacToe::Game.new
  game.start
  start_game if game.play_again?
end
start_game
