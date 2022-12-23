# frozen_string_literal: true

require 'colorize'

module TicTacToe
  # Updates board for all players
  class Player
    attr_reader :player_name

    def initialize(player_mark, player_color)
      @player_mark = player_mark
      @player_color = player_color
    end

    private

    def make_move!(move, positions, board)
      board.update(move, positions, @player_mark, @player_color)
    end
  end
end
