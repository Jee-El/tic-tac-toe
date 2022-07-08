require './messages'

module TicTacToe
  class Game
    include Messages

    WIN_COMBINATIONS = [[1, 2, 3],
                        [4, 5, 6],
                        [7, 8, 9],
                        [1, 4, 7],
                        [2, 5, 8],
                        [3, 6, 9],
                        [1, 5, 9],
                        [3, 5, 7]].freeze

    def initialize
      welcome

      @board = "\n 1 | 2 | 3\n-----------\n 4 | 5 | 6\n-----------\n 7 | 8 | 9\n\n"

      @first_player = Human.new

      build_players

      ask_for_input

      @is_single_player ? play_single_player : play_multiplayer

      report_results
    end

    def build_players
      loop do
        ask_for_game_type
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

    def play_single_player
      until @first_player.wins? || @second_player.wins? || Player.ties?(@board)
        @first_player_move = gets.chomp
        if @first_player.make_move(@board, @first_player_move, 'X') && !@first_player.wins? && !Player.ties?(@board)
          @second_player.make_move(@board, @first_player_move, 'O')
        end
        puts @board
      end
    end

    def play_multiplayer
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
      if @first_player.wins? || @second_player.wins?
        announce_winner(@first_player.wins? ? @first_player : @second_player)
      else
        announce_a_tie
      end
    end
  end

  class Player < Game
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

    def make_move(board, move, mark)
      save_move(move)
      board.sub!(move, mark)
    end

    def save_move(move)
      @past_moves.push(move.to_i)
    end
  end

  # Humans can pick their own moves
  class Human < Player
    def initialize
      super
      puts TTY::Box.frame('Enter your name', padding: [0, 1], align: :center, border: :light)
      @player_name = gets.chomp
      puts "\n"
    end

    def make_move(board, move, mark)
      return unless legal_move?(board, move)

      super
    end

    def legal_move?(board, move)
      return true if (1..9).include?(move.to_i) && board.index(move)

      puts "\nPlease enter an appropriate number :"
    end
  end

  # Computer picks a random move
  class Computer < Player
    def initialize
      super
      @player_name = 'Computer'
      @possible_moves = [*(1..9)]
    end

    def make_move(board, occupied_move, mark)
      @possible_moves -= [occupied_move.to_i]
      @move = @possible_moves.sample.to_s
      @possible_moves -= [@move.to_i]
      super(board, @move, mark)
    end
  end
end

TicTacToe::Game.new
