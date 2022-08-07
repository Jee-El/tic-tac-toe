# frozen_string_literal: true

module TicTacToe
  # Humans can pick a move on their own
  class Human < Player
    def initialize(player_mark, player_color)
      super
      ask_for_name
      @player_name = gets.chomp
      puts
    end

    def make_move!(positions, board)
      move = ask_till_valid_move(positions, board)
      super(move, positions, board)
      move
    end

    private

    include Messages

    def legal_move?(move, positions)
      return true if (1..9).include?(move) && positions[move - 1].empty?

      invalid_move_error
    end

    def ask_till_valid_move(positions, board)
      move = gets.chomp.to_i
      until legal_move?(move, positions)
        board.draw
        move = gets.chomp.to_i
      end
      move
    end
  end
end
