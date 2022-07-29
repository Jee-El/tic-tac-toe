# frozen_string_literal: true

require './board'
require './player'
require './human'
require './random_computer'
require './smart_computer'

# Rules, board, game modes
class Game
  def initialize
    mark_board_positions
    @positions = Array.new(9) { '' }
  end

  def start
    clear_screen
    clarify_rules
    clarify_rules until rules_clear?
    clear_screen
    game_type
    clear_screen
    play
    over
  end

  def play_again?
    ask_for_another_game
    ask_for_another_game until ['', 'y', 'n'].include?(input = gets.chomp.downcase)
    input != 'n'
  end

  private

  include Board

  def game_type
    ask_for_game_type
    ask_for_game_type until %w[1 2].include?(input = gets.chomp)
    clear_screen
    if input == '1'
      @is_single_player = true
      single_player_difficulty
    else
      @first_player = Human.new('X', :green)
      @second_player = Human.new('O', :red)
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
    until ['', 'y', 'n'].include?(input = gets.chomp.downcase)
      ask_for_starting_player
      invalid_starting_player_error
    end
    clear_screen
    input == 'n' ? computer_starts_setup(difficulty_lvl) : human_starts_setup(difficulty_lvl)
    clear_screen
  end

  def human_starts_setup(difficulty_lvl)
    @starting_player = 'human'
    @first_player = Human.new('X', :green)
    @second_player = difficulty_lvl == 1 ? RandomComputer.new('O', :red) : SmartComputer.new('O', :red)
  end

  def computer_starts_setup(difficulty_lvl)
    @starting_player = 'computer'
    @first_player = difficulty_lvl == 1 ? RandomComputer.new('X', :green) : SmartComputer.new('X', :green)
    @second_player = Human.new('O', :red)
  end

  def play
    board
    return play_single_player if @is_single_player

    play_multiplayer(@first_player, @second_player)
  end

  def play_single_player
    @starting_player == 'human' ? play_single_player_human_first : play_single_player_computer_first
  end

  def over
    case check_winner
    when -1 then announce_winner @first_player.player_name
    when 1 then announce_winner @second_player.player_name
    when 0 then announce_a_tie
    end
  end

  def play_single_player_human_first
    until check_winner
      @first_player_move = @first_player.make_move(@positions, @numbers_then_marks)
      clear_screen_show_board
      break unless check_winner.nil?

      @second_player.make_move(@first_player_move, @positions, @numbers_then_marks)
      sleep 0.9 if check_winner.nil?
      clear_screen_show_board
    end
  end

  def play_single_player_computer_first
    until check_winner([1, -1])
      @first_player.make_move(@second_player_move, @positions, @numbers_then_marks, [1, -1])
      sleep 0.9 if check_winner([1, -1]).nil?
      clear_screen_show_board
      break unless check_winner([1, -1]).nil?

      @second_player_move = @second_player.make_move(@positions, @numbers_then_marks)
      clear_screen_show_board
    end
  end

  def play_multiplayer(current_player, other_player, index = 0)
    return if check_winner

    current_player.make_move(@positions, @numbers_then_marks)
    clear_screen_show_board
    play_multiplayer(other_player, current_player, 1 - index)
  end
end
