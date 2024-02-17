class_name PlayerPieceBase
extends Area2D

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

var value: int
var piece_name: String
var next_piece_name: String  

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _input_event(_viewport: Viewport, event:InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		SignalBus.emit_signal("piece_clicked", position, piece_name)

# ------------------------------------------------------------------------------------------------ #

## Simple helper to check if a board square location is occupied. All Children of this class will want to be 
## able to use this
func _is_location_occupied(grid_location: Vector2, board: Array) -> bool:
	return board[grid_location.x][grid_location.y] != null
	
# ------------------------------------------------------------------------------------------------ #

## Simple helper to check if a grid_location is in bounds. All children of this class will want to 
## be able to use this
func _is_location_in_bounds(grid_location: Vector2, board_width: int, board_height: int) -> bool:
	if (
		grid_location.x < board_width and grid_location.x >= 0 
		and grid_location.y < board_height and grid_location.y >= 0
	):
		return true
	
	return false

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

func calculate_possible_moves(_board: Array, _current_grid_location: Vector2, _board_width: int, _board_height: int) -> Array:
	printerr("!!! BASE CLASS FUNCTION CALLED: calculate_possible_moves() in PlayerPieceBase !!!")
	return []
