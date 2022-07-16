require './messages'
require './win_checker'

module TicTacToe
  class Game
    include Messages

    def initialize
      clear_screen

      @board = " 1 | 2 | 3\n#{'-' * 11}\n 4 | 5 | 6\n#{'-' * 11}\n 7 | 8 | 9\n\n"
      @positions = Array.new(9) { '' }

      game_type

      play

      play_again
    end

    private

    def play
      if @is_single_player
        play_single_player
        game_over(@first_player_win_value, @second_player_win_value)
      else
        ask_for_input
        puts @board
        play_multiplayer(@first_player, @second_player)
        game_over
      end
    end

    def clear_screen
      puts "\e[1;1H\e[2J"
      welcome
    end

    include WinChecker
    def game_type
      loop do
        ask_for_game_type
        case gets.chomp
        when '1'
          clear_screen
          @is_single_player = true
          break single_player_difficulty
        when '2'
          clear_screen
          @is_single_player = false
          @first_player = Human.new('X')
          break @second_player = Human.new('O')
        end
      end
    end

    def single_player_difficulty
      loop do
        ask_for_difficulty_lvl
        case gets.chomp
        when '1'
          clear_screen
          break starting_player(1)
        when '2'
          clear_screen
          break starting_player(2)
        else
          puts "\nEnter '1' for easy, '2' for hard\n\n"
        end
      end
    end

    def starting_player(difficulty_lvl)
      loop do
        ask_for_starting_player
        case gets.chomp.downcase
        when 'y'
          clear_screen
          @starting_player = 'human'
          @first_player = Human.new('X')
          @second_player = difficulty_lvl == 1 ? RandomComputer.new('O') : SmartComputer.new('O')
          clear_screen
          break
        when 'n'
          clear_screen
          @starting_player = 'computer'
          @first_player = difficulty_lvl == 1 ? RandomComputer.new('X') : SmartComputer.new('X')
          @second_player = Human.new('O')
          clear_screen
          break
        else
          puts "\nEnter 'y' to go first, 'n' to go second\n\n"
        end
      end
    end

    def play_single_player
      @starting_player == 'human' ? play_single_player_human_first : play_single_player_computer_first
    end

    def play_single_player_human_first
      @first_player_win_value = -1
      @second_player_win_value = 1

      ask_for_input
      puts @board

      until check_winner
        @first_player_move = gets.chomp.to_i
        if @first_player.make_move(@first_player_move, @board, @positions) && check_winner.nil?
          @second_player.make_move(@first_player_move, @board, @positions, [-1, 1])
          clear_screen
        end
        puts @board
      end
    end

    def play_single_player_computer_first
      @first_player_win_value = 1
      @second_player_win_value = -1

      until check_winner([1, -1])
        @first_player.make_move(@second_player_move, @board, @positions, [1, -1])
        clear_screen
        puts @board
        break unless check_winner([1, -1]).nil?

        @second_player_move = gets.chomp.to_i
        until @second_player.make_move(@second_player_move, @board, @positions)
          puts @board
          @second_player_move = gets.chomp.to_i
        end
        puts @board
      end
    end

    def play_multiplayer(current_player, other_player, index = 0)
      return if check_winner

      move = gets.chomp.to_i
      until current_player.make_move(move, @board, @positions)
        puts @board
        move = gets.chomp.to_i
      end
      clear_screen
      puts @board
      play_multiplayer(other_player, current_player, 1 - index)
    end

    def game_over(first_player_win_value = -1, second_player_win_value = 1)
      case check_winner([first_player_win_value, second_player_win_value])
      when -1 then announce_winner @first_player.player_name
      when 1 then announce_winner @second_player.player_name
      when 0 then announce_a_tie
      end
    end

    def play_again
      loop do
        ask_for_another_game
        case gets.chomp.downcase
        when 'y' then break TicTacToe::Game.new
        when 'n' then break
        end
      end
    end
  end

  class Player
    include Messages
    attr_reader :player_name

    def initialize(mark)
      @mark = mark
    end

    private

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

    def make_move(move, board, positions)
      return unless legal_move? move, positions

      super
    end

    private

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
        if score > best_score
          best_score = score
          @best_move = i + 1
        end
      end
    end

    include WinChecker
    def minimax(positions, is_maximizing, win_values)
      result = check_winner(win_values, positions)
      return result if result

      if is_maximizing
        best_score = -Float::INFINITY
        positions.each_with_index do |elem, i|
          next unless elem.empty?

          positions[i] = @mark
          score = minimax(positions, false, win_values)
          positions[i] = ''
          best_score = [score, best_score].max
        end
      else
        best_score = Float::INFINITY
        positions.each_with_index do |elem, i|
          next unless elem.empty?

          positions[i] = @other_mark
          score = minimax(positions, true, win_values)
          positions[i] = ''
          best_score = [score, best_score].min
        end
      end
      best_score
    end
  end
end

TicTacToe::Game.new
