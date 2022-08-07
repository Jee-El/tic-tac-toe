# frozen_string_literal: true

require 'tty-box'

module TicTacToe
  # Messages to be displayed to the player(s)
  module Messages
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
      puts "\nPress enter to proceed\n\n"
      gets.chomp.downcase.empty?
    end

    def ask_for_name
      puts TTY::Box.frame('Type your name', padding: [0, 1], align: :center, border: :light)
      puts
    end

    def ask_for_game_mode
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
                          title: {  top_center: ' The Winner Is ',
                                    bottom_center: ' Good Game ' })
      puts
    end

    def announce_a_tie
      puts TTY::Box.frame('It\'s A Tie',
                          padding: [1, 1],
                          align: :center,
                          title: {  top_center: ' No Winner ',
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

    def invalid_move_error
      puts "\nPlease enter an appropriate number\n\n"
    end

    def invalid_starting_player_error
      puts "\nPress enter or type y to go first, n to go second\n\n"
    end

    def clear_screen
      puts "\e[1;1H\e[2J"
      welcome
    end

    def clear_screen_show_board
      clear_screen
      board.draw
    end
  end
end
