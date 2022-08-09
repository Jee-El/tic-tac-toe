# frozen_string_literal: true

require './player'

module TicTacToe
  # Computer picks a random move
  class RandomComputer < Player
    def initialize(player_mark, player_color)
      super
      @player_name = 'Computer'
      @possible_moves = *(1..9)
    end

    def make_move!(occupied_move, positions, board, _win_values = [-1, 1])
      @possible_moves.delete(occupied_move)
      move = @possible_moves.sample
      @possible_moves.delete(move)
      super(move, positions, board)
    end
  end
end
