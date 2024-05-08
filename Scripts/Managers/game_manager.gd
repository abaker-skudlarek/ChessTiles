extends Node

## This Scene/File will manage the game. It will keep track of the current state that the game is in
## and use signals every time the state is changed. Subscribers will then take actions based on the
## state that the game is now in.
##
## This is autoloaded, so it is a Singleton, meaning everything can access it. 

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

enum GameState {
	START_GAME,
	WAITING_USER_INPUT,
	SLIDE_MOVE,
	CHESS_MOVE,
	MERGING,
	SCORING,
	GAME_OVER,
	TWEENING,
}

# NOTE: I'm putting this here in the game manager because multiple scripts need to use these states
enum BoardLocationStates {
	OCCUPIED_PLAYER,  # Board location is occupied by a player piece
	OCCUPIED_ENEMY,   # Board location is occupied by an enemy piece
	NOT_OCCUPIED,     # Board location is not occupied
	ERROR,			  # Default state
}

const INITIAL_CHESS_MOVES: int = 5
# NOTE: I'm putting this here in the game manager because multiple scripts need to use these states
const PLAYER_FAMILY: String = "player"
const ENEMY_FAMILY: String = "enemy"

var _current_state: GameState     # Keeps track of the current state the game is in
var _slide_move_counter: int = 0  # Holds the amount of slide moves that have been performed during the game
var _chess_move_counter: int = 0  # Holds the amount of chess moves that have been performed during the game
var _chess_moves_remaining: int:  # Holds the amount of chess moves that the player can still use
	set(value):  # Using a setter so that the value is never set below 0
		_chess_moves_remaining = 0 if value < 0 else value

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("game_initialized", _on_game_initialized)
	SignalBus.connect("slide_move_finished", _on_slide_move_finished)
	SignalBus.connect("chess_move_finished", _on_chess_move_finished)
	SignalBus.connect("chess_move_gained", _on_chess_move_gained)

	# TODO: This will be moved somewhere else once we get a title screen. When "start game" is pressed, 
	# 		the state will be changed
	change_state(GameState.START_GAME)
	
# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_finished() -> void:
	_slide_move_counter += 1
	
# ------------------------------------------------------------------------------------------------ #

func _on_chess_move_finished() -> void:
	_chess_move_counter += 1
	_chess_moves_remaining -= 1
	SignalBus.emit_signal("chess_moves_remaining_updated", _chess_moves_remaining)
	
# ------------------------------------------------------------------------------------------------ #

func _on_chess_move_gained(num_moves_gained: int) -> void:
	_chess_moves_remaining += num_moves_gained
	SignalBus.emit_signal("chess_moves_remaining_updated", _chess_moves_remaining)
	
# ------------------------------------------------------------------------------------------------ #

func _on_game_initialized() -> void:
	_chess_moves_remaining = INITIAL_CHESS_MOVES
	SignalBus.emit_signal("chess_moves_remaining_updated", _chess_moves_remaining)

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Used to change the current state of the game. When called, the state will be changed to the passed
## in state, the appropriate signal will be emitted, and then any code that GameManager needs to run 
## for that state will be executed.
func change_state(new_state: GameState, signal_arguments: Dictionary = {}) -> void:
	_current_state = new_state

	match _current_state:
		GameState.START_GAME:
			SignalBus.emit_signal("state_changed_start_game")
		GameState.WAITING_USER_INPUT:
			SignalBus.emit_signal("state_changed_waiting_user_input")
		GameState.SLIDE_MOVE:
			SignalBus.emit_signal("state_changed_slide_move")
		GameState.CHESS_MOVE:
			SignalBus.emit_signal("state_changed_chess_move")
		GameState.MERGING:
			SignalBus.emit_signal("state_changed_merging")
		GameState.SCORING:
			SignalBus.emit_signal("state_changed_scoring", signal_arguments)
		GameState.GAME_OVER:
			SignalBus.emit_signal("state_changed_game_over")

# ------------------------------------------------------------------------------------------------ #

func get_current_game_state() -> GameState:
	return _current_state

# ------------------------------------------------------------------------------------------------ #

func get_slide_move_count() -> int:
	return _slide_move_counter

# ------------------------------------------------------------------------------------------------ #

func get_chess_move_count() -> int:
	return _chess_move_counter

# ------------------------------------------------------------------------------------------------ #

func get_chess_moves_remaining() -> int:
	return _chess_move_counter
	
# ------------------------------------------------------------------------------------------------ #

func is_chess_move_allowed() -> bool:
	return _chess_moves_remaining != 0

# ------------------------------------------------------------------------------------------------ #
