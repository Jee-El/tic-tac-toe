# frozen_string_literal: true

require_relative 'game_setup/game_setup'
require_relative 'game/multiplayer_game/multiplayer_game'
require_relative 'game/single_player_game/easy_single_player_game'
require_relative 'game/single_player_game/hard_single_player_game'

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
