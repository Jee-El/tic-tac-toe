# frozen_string_literal: true

# human vs random/smart computer
module SinglePlayerGameMode
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
    input == 'n' ? setup_computer_to_start(difficulty_lvl) : setup_human_to_start(difficulty_lvl)
    clear_screen
  end

  def play_single_player_game
    @starting_player == 'human' ? play_single_player_human_first : play_single_player_computer_first
  end

  def setup_human_to_start(difficulty_lvl)
    @starting_player = 'human'
    @first_player = Human.new('X', :green)
    @second_player = difficulty_lvl == 1 ? RandomComputer.new('O', :red) : SmartComputer.new('O', :red)
  end

  def setup_computer_to_start(difficulty_lvl)
    @starting_player = 'computer'
    @first_player = difficulty_lvl == 1 ? RandomComputer.new('X', :green) : SmartComputer.new('X', :green)
    @second_player = Human.new('O', :red)
  end

  def play_single_player_human_first
    until check_winner
      @first_player_move = @first_player.make_move!(@positions, @board)
      clear_screen_show_board
      break unless check_winner.nil?

      @second_player.make_move!(@first_player_move, @positions, @board)
      sleep 0.9 if check_winner.nil?
      clear_screen_show_board
    end
  end

  def play_single_player_computer_first
    until check_winner([1, -1])
      @first_player.make_move!(@second_player_move, @positions, @board, [1, -1])
      sleep 0.9 if check_winner([1, -1]).nil?
      clear_screen_show_board
      break unless check_winner([1, -1]).nil?

      @second_player_move = @second_player.make_move!(@positions, @board)
      clear_screen_show_board
    end
  end
end
