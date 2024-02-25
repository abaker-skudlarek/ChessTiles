extends PlayerPieceBase

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	value = 5
	piece_name = "player_rook"
	next_piece_name = "player_queen"

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
		Vector2(-1, +0)   # Left
	]    
	
	# Iterate through each possible direction the Rook can move
	for direction: Vector2 in move_directions:
		
		# This is the location that we are currently looking at. Every time we change directions,
		# we need to reset it to the position of the Rook that wants to move
		var current_check_location := current_grid_location
		
		# While the position that we are checking is in bounds
		while super._is_location_in_bounds(current_check_location, board_width, board_height):
			
			# Calculate the location that we want to move to 
			var possible_move_location: Vector2 = current_check_location + direction
		
			# If the location we want to move to is in bounds, and NOT occupied, append the location
			# to the array of possible moves
			if (
				super._is_location_in_bounds(possible_move_location, board_width, board_height)
				and not super._is_location_occupied(possible_move_location, board)
			):
				possible_moves.append(possible_move_location)
				# Set the next location to check
				current_check_location = possible_move_location 
			else:
				break

	return possible_moves
	
	
	
