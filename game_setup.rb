# frozen_string_literal: true

require_relative './messages'
require_relative './board'
require_relative './game'
require_relative './multiplayer_game'
require_relative './single_player_game'
require_relative './easy_single_player_game'
require_relative './hard_single_player_game'
require_relative './player'
require_relative './human'
require_relative './random_computer'
require_relative './smart_computer'

module TicTacToe
  # Setup game mode, starting player, game difficulty
  class GameSetup
    attr_reader :settings

    def initialize
      @settings = {}
    end

    def start
      clear_screen
      clarify_rules
      clarify_rules until rules_clear?
      clear_screen
      setup_game_mode(game_mode)
    end

    private

    include Messages

    def game_mode
      game_modes = { '1' => 'single player', '2' => 'multiplayer' }
      ask_for_game_mode
      ask_for_game_mode until %w[1 2].include?(mode = gets.chomp)
      clear_screen
      game_modes[mode]
    end

    def setup_game_mode(mode)
      @settings[:mode] = mode
      starting_player if mode == 'single player'
    end

    def starting_player
      starting_players_by_input = { 'human' => ['', 'y'], 'computer' => ['n']}
      ask_for_starting_player
      until starting_players_by_input.values.flatten.include?(input = gets.chomp.downcase)
        ask_for_starting_player
        invalid_starting_player_error
      end
      clear_screen
      starting_players_by_input.each do |starting_player, corresponding_input|
        next unless corresponding_input.include?(input)

        break @settings[:starting_player] = starting_player
      end
      single_player_game_difficulty
    end

    def single_player_game_difficulty
      difficulty_lvls = { '1' => 'easy', '2' => 'hard' }
      ask_for_difficulty_lvl
      ask_for_difficulty_lvl until %w[1 2].include?(difficulty_lvl = gets.chomp)
      clear_screen
      @settings[:difficulty] = difficulty_lvls[difficulty_lvl]
    end
  end
end
