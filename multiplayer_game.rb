# frozen_string_literal: true

module TicTacToe
  # human vs human
  class MultiplayerGame < Game
    def initialize
      super
      @first_player = Human.new('X', :green)
      @second_player = Human.new('O', :red)
    end

    def play(current_player = @first_player, other_player = @second_player, index = 0)
      return if board.check_winner

      current_player.make_move!(positions, @board)
      clear_screen_show_board
      play(other_player, current_player, 1 - index)
    end
  end
end
