class_name PlayerPieceBase
extends Area2D

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

enum BoardLocationStates {
	OCCUPIED_PLAYER,  # Board location is occupied by a player piece
	OCCUPIED_ENEMY,   # Board location is occupied by an enemy piece
	NOT_OCCUPIED,     # Board location is not occupied
	ERROR			  # Default state
}

const PLAYER = "player"
const ENEMY = "enemy"

var value: int
var piece_name: String
var next_piece_name: String  

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _input_event(_viewport: Viewport, event:InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("emitting signal player_piece_clicked")	
		SignalBus.emit_signal("player_piece_clicked", position, piece_name)

# ------------------------------------------------------------------------------------------------ #

## Helper to check if a board square location is occupied, and if so, by who. All Children of this 
## class will want to be able to use this
func _is_location_occupied(grid_location: Vector2, board: Array) -> BoardLocationStates:
	var board_location_contents: Node = board[grid_location.x][grid_location.y]
	var state: BoardLocationStates = BoardLocationStates.ERROR  # Error state should not be returned, it should be set to one of the other ones. If not, bug.
	
	if board_location_contents == null:
		state = BoardLocationStates.NOT_OCCUPIED
	elif PLAYER in board_location_contents.piece_name:
		state = BoardLocationStates.OCCUPIED_PLAYER
	elif ENEMY in board_location_contents.piece_name:
		state = BoardLocationStates.OCCUPIED_ENEMY
		
	return state
	
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

## Calculates all of the possible moves that can be made based on where the piece is, and what 
## pieces are in the other squares in the possible move range of the piece.
## This method should never be called. All of the children of this class will override it
func calculate_possible_moves(_board: Array, _current_grid_location: Vector2, _board_width: int, _board_height: int) -> Dictionary:
	printerr("!!! BASE CLASS FUNCTION CALLED: calculate_possible_moves() in PlayerPieceBase !!!")
	return {}
