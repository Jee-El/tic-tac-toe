# frozen_string_literal: true

require './player'

# Humans can pick their own moves
class Human < Player
  def initialize(mark)
    super
    ask_for_name
    @player_name = gets.chomp
    puts "\n"
  end

  def legal_move?(move, positions)
    return true if (1..9).include?(move) && positions[move - 1].empty?

    puts "\nPlease enter an appropriate number\n\n"
  end
end
