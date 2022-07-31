# frozen_string_literal: true

require 'colorize'

# Updates board for all players
class Player
  attr_reader :player_name

  private

  def initialize(player_mark, player_color)
    @player_mark = player_mark
    @player_color = player_color
  end

  def make_move!(move, positions, board)
    positions[move - 1] = @player_mark
    # The space around the character is important because
    # the colorize methods contain numbers and
    # they can conflict with the board's positions
    board.sub!(/ #{move} /, " #{@player_mark.colorize(@player_color)} ")
  end
end
