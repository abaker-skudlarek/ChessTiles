extends PlayerPieceBase

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	value = 20
	piece_name = "player_king"
	next_piece_name = ""

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

func calculate_possible_moves(board: Array, current_grid_location: Vector2, board_width: int, board_height: int) -> Array:
	var possible_moves := []
	
	# Define the possible directions that the Rook can move
	var move_directions := [ 
		Vector2(+0, -1),  # Up 
		Vector2(+1, +0),  # Right
		Vector2(+0, +1),  # Down
		Vector2(-1, +0),  # Left
		Vector2(-1, -1),  # Up Left 
		Vector2(+1, -1),  # Up Right
		Vector2(+1, +1),  # Down Right
		Vector2(-1, +1)   # Down Left
	]    
	
	for direction: Vector2 in move_directions:
		var possible_move_location: Vector2 = current_grid_location + direction
		
		# If the location we want to move to is in bounds, and NOT occupied, append the location
		# to the array of possible moves
		if (
			super._is_location_in_bounds(possible_move_location, board_width, board_height)
			and not super._is_location_occupied(possible_move_location, board)
		):
			possible_moves.append(possible_move_location)

	return possible_moves
