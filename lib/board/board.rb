# frozen_string_literal: true

module TicTacToe
  # Make a board, check winner
  class Board
    WIN_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

    def initialize
      @board = "#{'-' * 13}\n| 1 | 2 | 3 |\n#{'-' * 13}\n| 4 | 5 | 6 |\n#{'-' * 13}\n| 7 | 8 | 9 |\n#{'-' * 13}\n\n"
    end

    def to_s
      draw
    end

    def draw
      puts @board
    end

    def update(move, positions, player_mark, player_color)
      positions[move - 1] = player_mark
      # The space around the character is important because
      # the colorize methods contain numbers and
      # they can conflict with the board's positions
      @board.sub!(/ #{move} /, " #{player_mark.colorize(player_color)} ")
    end

    # Method to check for win, loss, tie
    # The returned values are mainly for minimax algorithm
    def check_winner(positions, win_values = [-1, 1])
      WIN_COMBINATIONS.each do |win_combo|
        return win_values[0] if win_combo.all? { |pos| positions[pos - 1] == 'X' }
        return win_values[1] if win_combo.all? { |pos| positions[pos - 1] == 'O' }
      end
      return 0 if positions.none?(&:empty?)
    end
  end
end
