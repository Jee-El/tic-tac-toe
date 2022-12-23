# frozen_string_literal: true

require_relative 'player'

module TicTacToe
  # Smart computer picks the best possible move
  # Uses minimax algorithm
  class SmartComputer < Player
    def initialize(player_mark, player_color)
      super
      @player_name = 'AI'
      @other_mark = @player_mark == 'X' ? 'O' : 'X'
      @possible_moves = *(1..9)
    end

    def make_move!(occupied_move, positions, board, win_values = [-1, 1])
      unless occupied_move
        @possible_moves.delete(1)
        return super(1, positions, board)
      end
      @possible_moves.delete(occupied_move)
      best_move(@possible_moves, positions, board, win_values, -Float::INFINITY, Float::INFINITY)
      @possible_moves.delete(@best_move)
      super(@best_move, positions, board)
    end

    private

    def best_move(possible_moves, positions, board, win_values, alpha, beta)
      best_score = -Float::INFINITY
      possible_moves.each do |possible_move|
        positions[possible_move - 1] = @player_mark
        score = minimax(possible_moves - [possible_move], positions, board, false, win_values, alpha, beta)
        positions[possible_move - 1] = ''
        (best_score = score) && (@best_move = possible_move) if score > best_score
        break if best_score >= beta
        alpha = [best_score, alpha].max
      end
    end

    def minimax(possible_moves, positions, board, is_maximizing, win_values, alpha, beta)
      result = board.check_winner(positions, win_values)
      return result if result

      if is_maximizing
        maximize(possible_moves, positions, board, win_values, alpha, beta)
      else
        minimize(possible_moves, positions, board, win_values, alpha, beta)
      end
    end

    def maximize(possible_moves, positions, board, win_values, alpha, beta)
      best_score = -Float::INFINITY
      possible_moves.each do |possible_move|
        positions[possible_move - 1] = @player_mark
        score = minimax(possible_moves - [possible_move], positions, board, false, win_values, alpha, beta)
        positions[possible_move - 1] = ''
        best_score = [score, best_score].max
        break if best_score >= beta
        alpha = [best_score, alpha].max
      end
      best_score
    end

    def minimize(possible_moves, positions, board, win_values, alpha, beta)
      best_score = Float::INFINITY
      possible_moves.each do |possible_move|
        positions[possible_move - 1] = @other_mark
        score = minimax(possible_moves - [possible_move], positions, board, true, win_values, alpha, beta)
        positions[possible_move - 1] = ''
        best_score = [score, best_score].min
        break if best_score <= alpha
        beta = [best_score, beta].min
      end
      best_score
    end
  end
end
