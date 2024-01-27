extends Node

# -- Game Manager Signals -- #
signal state_changed_start_game
signal state_changed_waiting_user_input
signal state_changed_slide_move
signal state_changed_chess_move
signal state_changed_win
signal state_changed_lose

# -- Input Manager Signals -- #
signal slide_move_left
signal slide_move_right
signal slide_move_up
signal slide_move_down
