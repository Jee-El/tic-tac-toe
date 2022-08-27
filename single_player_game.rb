# frozen_string_literal: true

require './game'
require './human'

module TicTacToe
  # human vs computer
  class SinglePlayerGame < Game
    def initialize(starting_player)
      @starting_player = starting_player
      case @starting_player
      when 'computer' then @second_player = Human.new('O', :red)
      else @first_player = Human.new('X', :green)
      end
      super()
    end

    def play
      super
      case @starting_player
      when 'computer' then play_computer_first
      when 'human' then play_human_first
      end
      over
    end

    private

    def play_human_first
      until board.check_winner(positions)
        @first_player_move = @first_player.make_move!(positions, board)
        clear_screen_show_board
        break unless board.check_winner(positions).nil?

        @second_player.make_move!(@first_player_move, positions, board)
        sleep 0.9 if board.check_winner(positions).nil?
        clear_screen_show_board
      end
    end

    def play_computer_first
      until board.check_winner(positions, [1, -1])
        @first_player.make_move!(@second_player_move, positions, board, [1, -1])
        sleep 0.9 if board.check_winner(positions, [1, -1]).nil?
        clear_screen_show_board
        break unless board.check_winner(positions, [1, -1]).nil?

        @second_player_move = @second_player.make_move!(positions, board)
        clear_screen_show_board
      end
    end
  end
end
