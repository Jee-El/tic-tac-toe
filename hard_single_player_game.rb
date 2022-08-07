# frozen_string_literal: true

module TicTacToe
  # human vs smart computer/AI
  class HardSinglePlayerGame < SinglePlayerGame
    def initialize(starting_player)
      case starting_player
      when 'computer' then @first_player = SmartComputer.new('X', :green)
      when 'human' then @second_player = SmartComputer.new('O', :red)
      end
      super
    end
  end
end
