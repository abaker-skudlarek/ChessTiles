extends PlayerPieceBase

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	print("rook init called")
	value = 5
	piece_name = "rook"
	next_piece_name = "queen"

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

func calculate_possible_moves(_board: Array, _current_grid_location: Vector2, _board_width: int, _board_height: int) -> Array:
	print("rook calculate possible moves")
	return []	
		
	# TODO: This method will calculate the possible places that the piece can go, 
	# 		and return the list of Vector2 grid positions. We need to do this
	# 		for each piece. Start with a pawn to make it easy and be sure it works
