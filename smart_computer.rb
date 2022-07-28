# frozen_string_literal: true

require './player'
require './win_checker'

# Smart computer picks the best possible move
# Uses minimax algorithm
class SmartComputer < Player
  def initialize(mark)
    super
    @player_name = 'AI'
    @other_mark = @mark == 'X' ? 'O' : 'X'
    @possible_moves = [*(0..8)]
  end

  def make_move(occupied_move, board, positions, win_values = [-1, 1])
    unless occupied_move
      @possible_moves -= [0]
      return super(1, board, positions)
    end
    @possible_moves -= [occupied_move - 1]
    best_move(@possible_moves, positions, win_values, -Float::INFINITY, Float::INFINITY)
    @possible_moves -= [@best_move - 1]
    super(@best_move, board, positions)
  end

  private

  def best_move(possible_moves, positions, win_values, alpha, beta)
    best_score = -Float::INFINITY
    possible_moves.each do |possible_move|
      positions[possible_move] = @mark
      score = minimax(possible_moves - [possible_move], positions, false, win_values, alpha, beta)
      positions[possible_move] = ''
      (best_score = score) && (@best_move = possible_move + 1) if score > best_score
      alpha = [score, alpha].max
      break if alpha >= beta
    end
  end

  include WinChecker
  def minimax(possible_moves, positions, is_maximizing, win_values, alpha, beta)
    result = check_winner(win_values, positions)
    return result if result

    if is_maximizing
      maximize(possible_moves, positions, win_values, alpha, beta)
    else
      minimize(possible_moves, positions, win_values, alpha, beta)
    end
  end

  def maximize(possible_moves, positions, win_values, alpha, beta)
    best_score = -Float::INFINITY
    possible_moves.each do |possible_move|
      positions[possible_move] = @mark
      score = minimax(possible_moves - [possible_move], positions, false, win_values, alpha, beta)
      positions[possible_move] = ''
      best_score = [score, best_score].max
      alpha = [score, alpha].max
      break if alpha >= beta
    end
    best_score
  end

  def minimize(possible_moves, positions, win_values, alpha, beta)
    best_score = Float::INFINITY
    possible_moves.each do |possible_move|
      positions[possible_move] = @other_mark
      score = minimax(possible_moves - [possible_move], positions, true, win_values, alpha, beta)
      positions[possible_move] = ''
      best_score = [score, best_score].min
      beta = [score, beta].min
      break if alpha >= beta
    end
    best_score
  end
end
