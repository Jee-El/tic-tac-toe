module Game
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
  @@board = "\n \s |\s \s|\s \n\n  \s|\s \s|\s \n\n \s |\s \s|\s \n\n"

  def self.board
    @@board
  end

  # General settings for any player
  class Player
    @@possible_moves = [*(1..9)]

    def initialize
      @past_moves = []
    end

    def make_a_move(move)
      return unless legal_move?(move)

      save_move(move)
      reduce_possible_moves(move)
    end

    def wins?
      WIN_COMBINATIONS.any? { |win| @past_moves.permutation(3).include?(win) }
    end

    def self.ties?
      @@possible_moves.empty?
    end

    private

    def save_move(move)
      @past_moves.push(move)
    end

    def reduce_possible_moves(move)
      @@possible_moves -= [move]
    end

    def legal_move?(move)
      return true if @@possible_moves.include?(move)

      puts "\nPlease enter an appropriate number"
    end
  end

  # Human can pick their own moves
  class Human < Player
    def make_a_move(move)
      return unless super

      Game.board[POSITIONS[move]] = 'X'
    end
  end

  # Computer picks a random move
  class Computer < Player
    def make_a_move(move = @@possible_moves.sample)
      return unless super

      Game.board[POSITIONS[move]] = 'O'
    end
  end
end

human = Game::Human.new
bot = Game::Computer.new

puts 'Please enter a number between 1 and 9'

until human.wins? || bot.wins? || Game::Player.ties?
  input = gets.chomp.to_i
  bot.make_a_move if human.make_a_move(input) && !human.wins?
  puts Game.board
end

if human.wins?
  puts 'Incredible Victory!'
elsif bot.wins?
  puts 'You lost, nice try!'
else
  puts 'A Tie!'
end
