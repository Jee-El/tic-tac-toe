# frozen_string_literal: true

require './game'

module TicTacToe
  # human vs human
  class MultiplayerGame < Game
    def initialize
      super
      @first_player = Human.new('X', :green)
      @second_player = Human.new('O', :red)
    end

    def play
      super
      play_multiplayer
      over
    end

    private

    def play_multiplayer(current_player = @first_player, other_player = @second_player, index = 0)
      return if board.check_winner(positions)

      current_player.make_move!(positions, @board)
      clear_screen_show_board
      play_multiplayer(other_player, current_player, 1 - index)
    end
  end
end
