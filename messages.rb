require 'tty-box'

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
    puts "\n"
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
    puts "\n"
  end

  def ask_for_difficulty_lvl
    puts TTY::Box.frame("1 : Easy (random moves)\n\n2 : Hard (AI moves)",
                        padding: [1, 1],
                        align: :left,
                        title: { top_center: ' 1 or 2? ' })
    puts "\n"
  end

  def ask_for_starting_player
    puts TTY::Box.frame('You wanna go first[y/n]?',
                        padding: [0, 1],
                        align: :center,
                        border: :light)
    puts "\n"
  end

  def ask_for_input
    puts TTY::Box.frame(padding: [0, 1], align: :center, border: :light) { 'Enter a number between 1 and 9' }
    puts "\n"
  end

  def announce_winner(winner_name)
    puts TTY::Box.frame(winner_name,
                        padding: [1, 1],
                        align: :center,
                        title: {  top_center: ' THE WINNER IS ',
                                  bottom_center: ' Good Game ' })
    puts "\n"
  end

  def announce_a_tie
    puts TTY::Box.frame('IT\'S A TIE',
                        padding: [1, 1],
                        align: :center,
                        title: {  top_center: ' NO WINNER ',
                                  bottom_center: ' Good Game ' })
    puts "\n"
  end

  def ask_for_another_game
    puts TTY::Box.frame('Wanna play again[y/n]?',
                        padding: [0, 1],
                        align: :center,
                        border: :light)
    puts "\n"
  end
end
