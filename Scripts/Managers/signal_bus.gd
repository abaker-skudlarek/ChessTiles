extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Game Manager Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal state_changed_start_game
signal state_changed_waiting_user_input
signal state_changed_slide_move
signal state_changed_chess_move
signal state_changed_merging
signal state_changed_win
signal state_changed_lose

# ------------------------------------------------------------------------------------------------ #
# -- Input Manager Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal slide_move_left
signal slide_move_right
signal slide_move_up
signal slide_move_down

# ------------------------------------------------------------------------------------------------ #
# -- Board Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal slide_move_finished
signal chess_move_to_empty_square_finished
signal chess_move_to_enemy_square_finished

# ------------------------------------------------------------------------------------------------ #
# -- Piece Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal player_piece_clicked(piece_pixel_position: Vector2, piece_name: String)
signal enemy_piece_clicked(piece_pixel_position: Vector2, piece_name: String)

# ------------------------------------------------------------------------------------------------ #
# -- Move Overlay Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal empty_move_overlay_clicked(overlay_pixel_position: Vector2)
signal enemy_move_overlay_clicked(overlay_pixel_position: Vector2)