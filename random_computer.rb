# frozen_string_literal: true

require './player'

# Computer picks a random move
class RandomComputer < Player
  def initialize(mark)
    super
    @player_name = 'Computer'
    @possible_moves = [*(1..9)]
  end

  def make_move(occupied_move, board, positions, _win_values = [-1, 1])
    @possible_moves -= [occupied_move]
    move = @possible_moves.sample
    @possible_moves -= [move]
    super(move, board, positions)
  end
end
