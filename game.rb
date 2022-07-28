# frozen_string_literal: true

require './messages'
require './win_checker'
require './human'
require './random_computer'
require './smart_computer'

# Rules, board, game modes
class Game
  def initialize
    @board = " 1 | 2 | 3\n#{'-' * 11}\n 4 | 5 | 6\n#{'-' * 11}\n 7 | 8 | 9\n\n"
    @positions = Array.new(9) { '' }
    @is_single_player = false
  end

  def start
    clear_screen
    game_type
    play
    over
  end

  def play_again?
    ask_for_another_game
    ask_for_another_game until %w[y n].include?(input = gets.chomp.downcase)
    input == 'y'
  end

  private

  include Messages
  def clear_screen
    puts "\e[1;1H\e[2J"
    welcome
  end

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
    clear_screen
    input == 'y' ? human_starts_setup(difficulty_lvl) : computer_starts_setup(difficulty_lvl)
    clear_screen
  end

  def human_starts_setup(difficulty_lvl)
    @starting_player = 'human'
    @first_player = Human.new('X')
    @second_player = difficulty_lvl == 1 ? RandomComputer.new('O') : SmartComputer.new('O')
  end

  def computer_starts_setup(difficulty_lvl)
    @starting_player = 'computer'
    @first_player = difficulty_lvl == 1 ? RandomComputer.new('X') : SmartComputer.new('X')
    @second_player = Human.new('O')
  end

  def play
    return play_single_player if @is_single_player

    ask_for_input
    puts @board
    play_multiplayer(@first_player, @second_player)
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

  include WinChecker
  def over
    case check_winner
    when -1 then announce_winner @first_player.player_name
    when 1 then announce_winner @second_player.player_name
    when 0 then announce_a_tie
    end
  end

  def play_single_player_human_first
    ask_for_input
    puts @board

    until check_winner
      @first_player_move = ask_till_valid_move(@first_player)
      @first_player.make_move(@first_player_move, @board, @positions)
      check_winner.nil? && @second_player.make_move(@first_player_move, @board, @positions)
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
