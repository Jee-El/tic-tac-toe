# frozen_string_literal: true

require_relative '../board/board'
require_relative '../messages/messages'

module TicTacToe
  # Rules, board, game modes
  class Game
    include Messages

    def initialize
      @board = Board.new
      @positions = Array.new(9) { '' }
    end

    def play_again?
      ask_for_another_game
      ask_for_another_game until ['', 'y', 'n'].include?(input = gets.chomp.downcase)
      input != 'n'
    end

    private

    attr_reader :positions, :board

    def play
      clear_screen
      board.draw
    end

    def over
      case board.check_winner(positions)
      when -1 then announce_winner @first_player.player_name
      when 1 then announce_winner @second_player.player_name
      when 0 then announce_a_tie
      end
    end
  end
end
