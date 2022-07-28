# frozen_string_literal: true

# Updates board for all players
class Player
  include Messages
  attr_reader :player_name

  def initialize(mark)
    @mark = mark
  end

  def make_move(move, board, positions)
    positions[move - 1] = @mark
    board.sub!(move.to_s, @mark)
  end
end
