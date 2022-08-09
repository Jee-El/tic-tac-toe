# frozen_string_literal: true

require './game_setup'
require './multiplayer_game'
require './easy_single_player_game'
require './hard_single_player_game'

def start_game
  game_setup = TicTacToe::GameSetup.new
  game_setup.start
  case game_setup.settings[:mode]
  when 'single player' then game = single_player(game_setup)
  when 'multiplayer' then game = TicTacToe::MultiplayerGame.new
  end
  game.play
  start_game if game.play_again?
end

def single_player(game_setup)
  case game_setup.settings[:difficulty]
  when 'easy'
    TicTacToe::EasySinglePlayerGame.new(game_setup.settings[:starting_player])
  when 'hard'
    TicTacToe::HardSinglePlayerGame.new(game_setup.settings[:starting_player])
  end
end
start_game
