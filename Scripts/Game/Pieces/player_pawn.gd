extends PlayerPieceBase

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	value = 1
	piece_name = "player_pawn"
	next_piece_name = "player_bishop"

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

# TODO: We will want to check for enemies and make sure to show the opportunity to take them
func calculate_possible_moves(board: Array, current_grid_location: Vector2, board_width: int, board_height: int) -> Array:
	
	var possible_move_location := Vector2(current_grid_location.x, current_grid_location.y - 1)
	
	# If the possible move location is occupied, we can't move here
	if super._is_location_occupied(possible_move_location, board):
		return []
	
	# If the possible move is inside the board bounds, we can move here, return the location
	if super._is_location_in_bounds(possible_move_location, board_width, board_height):
		return [possible_move_location]

	# If we've gotten here, no moves are possible, return empty array
	return []	

