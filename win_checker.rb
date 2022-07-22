# frozen_string_literal: true

# Method to check for win, loss, tie
# The returned values are mainly for minimax algorithm
module WinChecker
  WIN_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def check_winner(win_values = [-1, 1], positions = @positions)
    WIN_COMBINATIONS.each do |win_combo|
      return win_values[0] if win_combo.all? { |pos| positions[pos - 1] == 'X' }
      return win_values[1] if win_combo.all? { |pos| positions[pos - 1] == 'O' }
    end
    return 0 if positions.none?(&:empty?)
  end
end
