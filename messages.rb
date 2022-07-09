gemfile true do
  source 'http://rubygems.org'
  gem 'tty-box'
end

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
  end

  def ask_for_name
    puts TTY::Box.frame('Enter your name', padding: [0, 1], align: :center, border: :light)
  end

  def ask_for_game_type
    puts TTY::Box.frame("1 : Single Player,\n\n2 : Multiplayer",
                        padding: [1, 1],
                        align: :left,
                        title: { top_center: ' Choose by typing the corresponding number : ' })
  end

  def ask_for_input
    puts TTY::Box.frame(padding: [0, 1], align: :center, border: :light) { 'Please enter a number between 1 and 9' }
  end

  def announce_winner(winner)
    puts TTY::Box.frame(winner.player_name,
                        padding: [1, 1],
                        align: :center,
                        title: {  top_center: ' THE WINNER IS ',
                                  bottom_center: ' Good Game ' })
  end

  def announce_a_tie
    puts TTY::Box.frame('IT\'S A TIE',
                        padding: [1, 1],
                        align: :center,
                        title: {  top_center: ' NO WINNER ',
                                  bottom_center: ' Good Game ' })
  end
end
