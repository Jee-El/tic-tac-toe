# frozen_string_literal: true

require 'tty-box'

# Messages to be displayed to the player(s)
module Board
  WIN_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  # Method to check for win, loss, tie
  # The returned values are mainly for minimax algorithm
  def check_winner(win_values = [-1, 1], positions = @positions)
    WIN_COMBINATIONS.each do |win_combo|
      return win_values[0] if win_combo.all? { |pos| positions[pos - 1] == 'X' }
      return win_values[1] if win_combo.all? { |pos| positions[pos - 1] == 'O' }
    end
    return 0 if positions.none?(&:empty?)
  end

  def welcome
    puts TTY::Box.frame("Welcome\n\nTo Tic Tac Toe",
                        padding: [1, 2],
                        align: :center,
                        border: :ascii,
                        enable_color: true,
                        style: {  bg: :blue,
                                  fg: :white })
    puts
  end

  def clarify_rules
    puts TTY::Box.frame("- Use numbers 1-9 to make a move\n\n"\
                        "- 1st player's mark -> #{'X'.green}\n\n"\
                        "- 2nd player's mark -> #{'O'.red}\n\n",
                        padding: [1, 1], border: :ascii)
  end

  def rules_clear?
    puts
    puts 'Are the rules clear[Y/n]?'
    puts
    response = gets.chomp.downcase
    response == 'y' || response.empty?
  end

  def mark_board_positions
    # The zero is just to make working with the array simpler, it's not used
    @numbers_then_marks = *(0..9)
  end

  def board
    # The colorizing gem uses combination of numbers/special characters
    # they can conflict with the board's positions/numbers
    puts " #{@numbers_then_marks[1]} | #{@numbers_then_marks[2]} | #{@numbers_then_marks[3]}\n"\
         "#{'-' * 11}\n"\
         " #{@numbers_then_marks[4]} | #{@numbers_then_marks[5]} | #{@numbers_then_marks[6]}\n"\
         "#{'-' * 11}\n"\
         " #{@numbers_then_marks[7]} | #{@numbers_then_marks[8]} | #{@numbers_then_marks[9]}\n\n"
  end

  def clear_screen
    puts "\e[1;1H\e[2J"
    welcome
  end

  def clear_screen_show_board
    clear_screen
    board
  end

  def ask_for_name
    puts TTY::Box.frame('Type your name', padding: [0, 1], align: :center, border: :light)
    puts "\n"
  end

  def ask_for_game_type
    puts TTY::Box.frame("1 : Single Player\n\n2 : Multiplayer",
                        padding: [1, 1],
                        align: :left,
                        title: { top_center: ' 1 or 2? ' })
    puts
  end

  def ask_for_difficulty_lvl
    puts TTY::Box.frame("1 : Easy (random moves)\n\n2 : Hard (AI moves)",
                        padding: [1, 1],
                        align: :left,
                        title: { top_center: ' 1 or 2? ' })
    puts
  end

  def ask_for_starting_player
    puts TTY::Box.frame('You wanna go first[Y/n]?',
                        padding: [0, 1],
                        align: :center,
                        border: :light)
    puts
  end

  def announce_winner(winner_name)
    puts TTY::Box.frame(winner_name,
                        padding: [1, 1],
                        align: :center,
                        title: {  top_center: ' THE WINNER IS ',
                                  bottom_center: ' Good Game ' })
    puts
  end

  def announce_a_tie
    puts TTY::Box.frame('IT\'S A TIE',
                        padding: [1, 1],
                        align: :center,
                        title: {  top_center: ' NO WINNER ',
                                  bottom_center: ' Good Game ' })
    puts
  end

  def ask_for_another_game
    puts TTY::Box.frame('Wanna play again[y/n]?',
                        padding: [0, 1],
                        align: :center,
                        border: :light)
    puts
  end
end
