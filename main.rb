# frozen_string_literal: true

require './tic_tac_toe'

def play
  current_game = TicTacToe::Game.new
  current_game.clear_screen
  current_game.game_type
  current_game.start
  current_game.over
  play if current_game.play_again?
end
play
