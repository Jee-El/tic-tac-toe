# frozen_string_literal: true

# human vs human
module MultiPlayerGameMode
  def play_multi_player_game(current_player = @first_player, other_player = @second_player, index = 0)
    return if check_winner

    current_player.make_move!(@positions, @board)
    clear_screen_show_board
    play_multi_player_game(other_player, current_player, 1 - index)
  end
end
