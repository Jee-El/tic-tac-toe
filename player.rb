# frozen_string_literal: true

require 'colorize'

# Updates board for all players
class Player
  attr_reader :player_name

  def initialize(player_mark, player_color)
    @player_mark = player_mark
    @player_color = player_color
  end

  def make_move(move, positions, numbers_then_marks)
    positions[move - 1] = @player_mark
    numbers_then_marks[move] = @player_mark.colorize(@player_color)
  end
end
