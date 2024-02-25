extends PlayerPieceBase

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	value = 3
	piece_name = "player_knight"
	next_piece_name = "player_rook"

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Calculates all of the possible moves that can be made based on where the piece is, and what 
## pieces are in the other squares in the possible move range of the piece.
func calculate_possible_moves(board: Array, current_grid_location: Vector2, board_width: int, board_height: int) -> Dictionary:

	# Holds an array for each possible move. One for empty spaces, one for spaces that contain an enemy
	var possible_moves := {
		"empty_spaces": [],
		"enemy_spaces": []
	}
	
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

	# Iterate through each possible direction the Knight can move	
	for direction: Vector2 in move_directions:

		# Calculate the location that we want to move to
		var possible_move_location: Vector2 = current_grid_location + direction
		
		# If the new possible move location is in bounds
		if super._is_location_in_bounds(possible_move_location, board_width, board_height):

			# Get the status of the location, so that we know if there is a piece on it or not
			var location_status: BoardLocationStates = super._is_location_occupied(possible_move_location, board)

			# If the location has a player piece on it, this isn't a possible move
			if location_status == BoardLocationStates.OCCUPIED_PLAYER:
				continue
			# If the location has an enemy piece on it, this isn't a possible move
			elif location_status == BoardLocationStates.OCCUPIED_ENEMY:
				possible_moves["enemy_spaces"].append(possible_move_location)
			# If the location doesn't have a piece on it, this is a possible move
			elif location_status == BoardLocationStates.NOT_OCCUPIED:
				possible_moves["empty_spaces"].append(possible_move_location)
			elif location_status == BoardLocationStates.ERROR:
				printerr("!!! BoardLocationState is ERROR. Something bad happened !!!")

	return possible_moves
