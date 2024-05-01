extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Game Manager Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal state_changed_start_game
signal state_changed_waiting_user_input
signal state_changed_slide_move
signal state_changed_chess_move
signal state_changed_merging
signal state_changed_scoring(signal_arguments: Dictionary)
signal state_changed_game_over
signal chess_moves_remaining_updated(num_moves: int)

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
signal game_initialized
signal slide_move_finished
signal chess_move_finished
signal pieces_merged
signal piece_taken(taken_piece_name: String)

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

# ------------------------------------------------------------------------------------------------ #
# -- Charge Bar Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal chess_move_gained(num_moves_gained: int)

# ------------------------------------------------------------------------------------------------ #
# -- End Game Scorer Signals -- #
# ------------------------------------------------------------------------------------------------ #
signal end_game_score_calculated(end_game_score: int) 
signal piece_scored(piece_value: int)
