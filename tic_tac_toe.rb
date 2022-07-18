# frozen_string_literal: true

require './messages'
require './win_checker'

module TicTacToe
  # Rules, board, game modes
  class Game
    include Messages

    def initialize
      @board = " 1 | 2 | 3\n#{'-' * 11}\n 4 | 5 | 6\n#{'-' * 11}\n 7 | 8 | 9\n\n"
      @positions = Array.new(9) { '' }
      @is_single_player = false
    end

    def clear_screen
      puts "\e[1;1H\e[2J"
      welcome
    end

    include WinChecker
    def game_type
      ask_for_game_type
      ask_for_game_type until %w[1 2].include?(input = gets.chomp)
      clear_screen
      if input == '1'
        @is_single_player = true
        single_player_difficulty
      else
        @first_player = Human.new('X')
        @second_player = Human.new('O')
      end
    end

    def start
      if @is_single_player
        play_single_player
      else
        ask_for_input
        puts @board
        play_multiplayer(@first_player, @second_player)
      end
    end

    def over
      case check_winner
      when -1 then announce_winner @first_player.player_name
      when 1 then announce_winner @second_player.player_name
      when 0 then announce_a_tie
      end
    end

    def play_again?
      ask_for_another_game
      ask_for_another_game until %w[y n].include?(input = gets.chomp.downcase)
      input == 'y'
    end

    private

    def single_player_difficulty
      ask_for_difficulty_lvl
      ask_for_difficulty_lvl until %w[1 2].include?(difficulty_lvl = gets.chomp)
      clear_screen
      starting_player(difficulty_lvl.to_i)
    end

    def starting_player(difficulty_lvl)
      ask_for_starting_player
      until %w[y n].include?(input = gets.chomp.downcase)
        ask_for_starting_player
        puts "\nEnter 'y' to go first, 'n' to go second\n\n"
      end
      input == 'y' ? human_starts_setup(difficulty_lvl) : computer_starts_setup(difficulty_lvl)
      clear_screen
    end

    def human_starts_setup(difficulty_lvl)
      clear_screen
      @starting_player = 'human'
      @first_player = Human.new('X')
      @second_player = difficulty_lvl == 1 ? RandomComputer.new('O') : SmartComputer.new('O')
    end

    def computer_starts_setup(difficulty_lvl)
      clear_screen
      @starting_player = 'computer'
      @first_player = difficulty_lvl == 1 ? RandomComputer.new('X') : SmartComputer.new('X')
      @second_player = Human.new('O')
    end

    def play_single_player
      @starting_player == 'human' ? play_single_player_human_first : play_single_player_computer_first
    end

    def ask_till_valid_move(player)
      move = gets.chomp.to_i
      until player.legal_move?(move, @positions)
        puts @board
        move = gets.chomp.to_i
      end
      move
    end

    def play_single_player_human_first
      ask_for_input
      puts @board

      until check_winner
        @first_player_move = ask_till_valid_move(@first_player)
        @first_player.make_move(@first_player_move, @board, @positions)
        check_winner.nil? && @second_player.make_move(@first_player_move, @board, @positions, [-1, 1])
        clear_screen
        puts @board
      end
    end

    def play_single_player_computer_first
      until check_winner([1, -1])
        @first_player.make_move(@second_player_move, @board, @positions, [1, -1])
        clear_screen
        puts @board
        break unless check_winner([1, -1]).nil?

        @second_player_move = ask_till_valid_move(@second_player)
        @second_player.make_move(@second_player_move, @board, @positions)
        puts @board
      end
    end

    def play_multiplayer(current_player, other_player, index = 0)
      return if check_winner

      current_player_move = ask_till_valid_move(current_player)
      current_player.make_move(current_player_move, @board, @positions)
      clear_screen
      puts @board
      play_multiplayer(other_player, current_player, 1 - index)
    end
  end

  # All players
  class Player
    include Messages
    attr_reader :player_name

    def initialize(mark)
      @mark = mark
    end

    def make_move(move, board, positions)
      positions[move - 1] = @mark
      board.sub!(move.to_s, @mark)
    end
  end

  # Humans can pick their own moves
  class Human < Player
    def initialize(mark)
      super
      ask_for_name
      @player_name = gets.chomp
      puts "\n"
    end

    def legal_move?(move, positions)
      return true if (1..9).include?(move) && positions[move - 1].empty?

      puts "\nPlease enter an appropriate number\n\n"
    end
  end

  # Computer picks a random move
  class RandomComputer < Player
    def initialize(mark)
      super
      @player_name = 'Computer'
      @possible_moves = [*(1..9)]
    end

    def make_move(occupied_move, board, positions, _win_values)
      occupied_move ||= 0
      @possible_moves -= [occupied_move]
      move = @possible_moves.sample
      @possible_moves -= [move]
      super(move, board, positions)
    end
  end

  # Computer picks a the best possible move
  # using minimax algorithm
  class SmartComputer < Player
    def initialize(mark)
      super
      @player_name = 'AI'
      @other_mark = @mark == 'X' ? 'O' : 'X'
    end

    def make_move(occupied_move, board, positions, win_values = [-1, 1])
      return super(1, board, positions) unless occupied_move

      best_move(positions, win_values)
      super(@best_move, board, positions)
    end

    private

    def best_move(positions, win_values)
      best_score = -Float::INFINITY
      positions.each_with_index do |elem, i|
        next unless elem.empty?

        positions[i] = @mark
        score = minimax(positions, false, win_values)
        positions[i] = ''
        (best_score = score) && (@best_move = i + 1) if score > best_score
      end
    end

    include WinChecker
    def minimax(positions, is_maximizing, win_values)
      result = check_winner(win_values, positions)
      return result if result

      is_maximizing ? maximize(positions, win_values) : minimize(positions, win_values)
    end

    def maximize(positions, win_values)
      best_score = -Float::INFINITY
      positions.each_with_index do |elem, i|
        next unless elem.empty?

        positions[i] = @mark
        score = minimax(positions, false, win_values)
        positions[i] = ''
        best_score = [score, best_score].max
      end
      best_score
    end

    def minimize(positions, win_values)
      best_score = Float::INFINITY
      positions.each_with_index do |elem, i|
        next unless elem.empty?

        positions[i] = @other_mark
        score = minimax(positions, true, win_values)
        positions[i] = ''
        best_score = [score, best_score].min
      end
      best_score
    end
  end
end
