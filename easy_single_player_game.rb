# frozen_string_literal: true

require './single_player_game'
require './random_computer'

module TicTacToe
  # human vs random/easy computer
  class EasySinglePlayerGame < SinglePlayerGame
    def initialize(starting_player)
      case starting_player
      when 'computer' then @first_player = RandomComputer.new('X', :green)
      when 'human' then @second_player = RandomComputer.new('O', :red)
      end
      super
    end
  end
end
