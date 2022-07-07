# User input interpreter & possible wins
module Settings
  POSITIONS = {
    1 => 2,
    2 => 6,
    3 => 10,
    4 => 14,
    5 => 18,
    6 => 22,
    7 => 26,
    8 => 30,
    9 => 34
  }.freeze
  WIN_COMBINATIONS = [[1, 2, 3],
                      [4, 5, 6],
                      [7, 8, 9],
                      [1, 4, 7],
                      [2, 5, 8],
                      [3, 6, 9],
                      [1, 5, 9],
                      [3, 5, 7]].freeze
end

# Game launch/start
class Game
  include Settings

  def initialize
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
    until @first_player.wins? || @second_player.wins? || Player.ties?
      @first_player_move = gets.chomp.to_i
      if @first_player.make_a_move(@first_player_move, 'X') && !@first_player.wins? && !Player.ties?
        @second_player.make_a_move
      end
      puts Player.board
    end
  end

  def multiplayer_game
    until @first_player.wins? || @second_player.wins? || Player.ties?
      @first_player_move = gets.chomp.to_i
      until @first_player.make_a_move(@first_player_move, 'X')
        puts Player.board
        @first_player_move = gets.chomp.to_i
      end
      puts Player.board
      if !@first_player.wins? && !Player.ties?
        @second_player_move = gets.chomp.to_i
        until @second_player.make_a_move(@second_player_move, 'O')
          puts Player.board
          @second_player_move = gets.chomp.to_i
        end
      end
      puts Player.board
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
class Player < Game
  attr_reader :player_name

  @@board = "\n\s\s\s|\s\s\s|\s\s\n\n\s\s\s|\s\s\s|\s\s\n\n\s\s\s|\s\s\s|\s\s\n\n"
  @@possible_moves = [*(1..9)]

  def initialize
    @past_moves = []
  end

  def self.board
    @@board
  end

  def wins?
    WIN_COMBINATIONS.any? { |win| @past_moves.permutation(3).include?(win) }
  end

  def self.ties?
    @@possible_moves.empty?
  end

  private

  def make_a_move(move)
    return unless legal_move?(move)

    save_move(move)
    reduce_possible_moves(move)
  end

  def legal_move?(move)
    return true if @@possible_moves.include?(move)

    puts "\nPlease enter an appropriate number"
  end

  def save_move(move)
    @past_moves.push(move)
  end

  def reduce_possible_moves(move)
    @@possible_moves -= [move]
  end
end

# Humans can pick their own moves
class Human < Player
  def initialize
    super
    puts 'Enter your name :'
    @player_name = gets.chomp
  end

  def make_a_move(move, mark)
    return unless super(move)

    @@board[POSITIONS[move]] = mark
  end
end

# Computer picks a random move
class Computer < Player
  def initialize
    super
    @player_name = 'Computer'
  end

  def make_a_move(move = @@possible_moves.sample)
    return unless super

    @@board[POSITIONS[move]] = 'O'
  end
end

Game.new
