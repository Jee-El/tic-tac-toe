# frozen_string_literal: true

# Game launch/start
class TicTacToe
  WIN_COMBINATIONS = [[1, 2, 3],
                      [4, 5, 6],
                      [7, 8, 9],
                      [1, 4, 7],
                      [2, 5, 8],
                      [3, 6, 9],
                      [1, 5, 9],
                      [3, 5, 7]].freeze

  def initialize
    @board = "\n 1 | 2 | 3\n-----------\n 4 | 5 | 6\n-----------\n 7 | 8 | 9\n\n"

    @first_player = Human.new

    build_players

    puts 'Please enter a number between 1 and 9'

    @is_single_player ? single_player_game : multiplayer_game

    report_results
  end

  def build_players
    loop do
      puts 'Choose by typing the corresponding number :'
      puts "1 => Single Player,\n2 => Multiplayer"
      @game_type = gets.chomp
      case @game_type
      when '1'
        @is_single_player = true
        @second_player = Computer.new
        break
      when '2'
        @is_single_player = false
        @second_player = Human.new
        break
      end
    end
  end

  def single_player_game
    until @first_player.wins? || @second_player.wins? || Player.ties?(@board)
      @first_player_move = gets.chomp
      if @first_player.make_move(@board, @first_player_move, 'X') && !@first_player.wins? && !Player.ties?(@board)
        @second_player.make_move(@board)
      end
      puts @board
    end
  end

  def multiplayer_game
    until @first_player.wins? || @second_player.wins? || Player.ties?(@board)
      @first_player_move = gets.chomp
      until @first_player.make_move(@board, @first_player_move, 'X')
        puts @board
        @first_player_move = gets.chomp
      end
      puts @board
      if !@first_player.wins? && !Player.ties?(@board)
        @second_player_move = gets.chomp
        until @second_player.make_move(@board, @second_player_move, 'O')
          puts @board
          @second_player_move = gets.chomp
        end
      end
      puts @board
    end
  end

  def report_results
    if @first_player.wins?
      puts "Ez win for #{@first_player.player_name}"
    elsif @second_player.wins?
      puts "Ez win for #{@second_player.player_name}"
    else
      puts 'A Tie!'
    end
  end
end

# General settings for any player
class Player < TicTacToe
  attr_reader :player_name

  def initialize
    @past_moves = []
  end

  def wins?
    WIN_COMBINATIONS.any? { |win| @past_moves.permutation(3).include?(win) }
  end

  def self.ties?(board)
    !board.match?(/\d+/)
  end

  private

  def make_move(board, move)
    return unless legal_move?(board, move)

    save_move(move)
  end

  def legal_move?(board, move)
    return true if board.index(move)

    puts "\nPlease enter an appropriate number"
  end

  def save_move(move)
    @past_moves.push(move.to_i)
  end
end

# Humans can pick their own moves
class Human < Player
  def initialize
    super
    puts 'Enter your name :'
    @player_name = gets.chomp
  end

  def make_move(board, move, mark)
    return unless super(board, move)

    board.sub!(move, mark)
  end
end

# Computer picks a random move
class Computer < Player
  def initialize
    super
    @player_name = 'Computer'
  end

  def make_move(board, move = [*(1..9)].sample)
    move = [[*(1..9)] - [move]].sample until board.index(move.to_s)
    move = move.to_s
    return unless super(board, move)

    board.sub!(move, 'O')
  end
end

TicTacToe.new
