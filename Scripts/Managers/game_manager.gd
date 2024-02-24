extends Node

## This Scene/File will manage the game. It will keep track of the current state that the game is in
## and use signals every time the state is changed. Subscribers will then take actions based on the
## state that the game is now in.
##
## This is autoloaded, so it is a Singleton, meaning everything can access it. 

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

# TODO: I'm not actually sure if we need these GameStates. Does a state machine matter in this case? I'm 
# 		not using it all the time, so may not actually be needed.
enum GameState {
	START_GAME,
	WAITING_USER_INPUT,
	SLIDE_MOVE,
	CHESS_MOVE,
	MERGING,
	WIN,
	LOSE
}

var _current_state: GameState

var slide_move_counter: int = 0  # Holds the amount of slide moves that have been performed during the game
var chess_move_counter: int = 0  # Holds the amount of chess moves that have been performed during the game
var chess_moves_left: int = 0    # Holds the amount of chess moves that the player can use

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("slide_move_finished", _on_slide_move_finished)
	SignalBus.connect("chess_move_finished", _on_chess_move_finished)
	
	# TODO: This will be moved somewhere else once we get a title screen. When "start game" is pressed, 
	# 		the state will be changed
	change_state(GameState.START_GAME)
	
# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_finished() -> void:
	slide_move_counter += 1
	
# ------------------------------------------------------------------------------------------------ #

func _on_chess_move_finished() -> void:
	chess_move_counter += 1
	chess_moves_left -= 1
	
# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Used to change the current state of the game. When called, the state will be changed to the passed
## in state, the appropriate signal will be emitted, and then any code that GameManager needs to run 
## for that state will be executed.
func change_state(new_state: GameState) -> void:
	_current_state = new_state
	
	#print("_current_state = ", GameState.keys()[new_state])

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
		GameState.WIN:
			SignalBus.emit_signal("state_changed_win")
		GameState.LOSE:
			SignalBus.emit_signal("state_changed_lose")

# ------------------------------------------------------------------------------------------------ #

func get_current_game_state() -> GameState:
	return _current_state

# ------------------------------------------------------------------------------------------------ #
