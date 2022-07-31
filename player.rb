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
    board.sub!(/\s#{move}\s/, " #{@player_mark.colorize(@player_color)} ")
  end
end
