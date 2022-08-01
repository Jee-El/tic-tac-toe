# frozen_string_literal: true

require './board'
require './player'
require './human'
require './random_computer'
require './smart_computer'
require './multi_player_game_mode'
require './single_player_game_mode'

module TicTacToe
  # Rules, board, game modes
  class Game
    def initialize
      @board = make_board
      @positions = Array.new(9) { '' }
    end

    def start
      clear_screen
      clarify_rules
      clarify_rules until rules_clear?
      clear_screen
      game_type
      clear_screen
      play
      over
    end

    def play_again?
      ask_for_another_game
      ask_for_another_game until ['', 'y', 'n'].include?(input = gets.chomp.downcase)
      input != 'n'
    end

    private

    include SinglePlayerGameMode
    include MultiPlayerGameMode
    include Board

    def game_type
      ask_for_game_type
      ask_for_game_type until %w[1 2].include?(input = gets.chomp)
      clear_screen
      if input == '1'
        @is_single_player_game = true
        single_player_difficulty
      else
        @first_player = Human.new('X', :green)
        @second_player = Human.new('O', :red)
      end
    end

    def play
      puts @board
      @is_single_player_game ? play_single_player_game : play_multi_player_game
    end

    def over
      case check_winner
      when -1 then announce_winner @first_player.player_name
      when 1 then announce_winner @second_player.player_name
      when 0 then announce_a_tie
      end
    end
  end
end
