# frozen_string_literal: true

require './game'

def start_game
  game = Game.new
  game.start
  start_game if game.play_again?
end
start_game
