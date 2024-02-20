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

# ------------------------------------------------------------------------------------------------ #
# -- Piece Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal piece_clicked(piece_pixel_position: Vector2, piece_name: String)

# ------------------------------------------------------------------------------------------------ #
# -- Square Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal light_square_clicked(square_pixel_position: Vector2)
signal dark_square_clicked(square_pixel_position: Vector2)
