extends PlayerPieceBase

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	print("knight init called")
	value = 3
	piece_name = "knight"
	next_piece_name = "rook"

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

func calculate_possible_moves(board: Array, current_grid_location: Vector2, board_width: int, board_height: int) -> Array:
	var possible_moves := []
	
	# Define the possible directions that the Knight can move
	var move_directions := [ 
		Vector2(-1, -2),  # Up Up Left
		Vector2(+1, -2),  # Up Up Right
		Vector2(+2, -1),  # Right Right Up
		Vector2(+2, +1),  # Right Right Down
		Vector2(+1, +2),  # Down Down Right
		Vector2(-1, +2),  # Down Down Left
		Vector2(-2, +1),  # Left Left Down
		Vector2(-2, -1)	  # Left Left Up
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
