extends Node

'''
This Scene/File will manage the game. It will keep track of the current state that the game is in
and use signals every time the state is changed. Subscribers will then take actions based on the
state that the game is now in.
'''

# -- Variables -- #

enum GameState {
	START_GAME,
	WAITING_USER_INPUT,
	SLIDE_MOVE,
	CHESS_MOVE,
	WIN,
	LOSE
}

var _current_state: GameState

# -- Private Functions -- #

func _ready():
	# TODO: This will be moved somewhere else once we get a title screen. When "start game" is pressed, 
	# 		the state will be changed
	_change_state(GameState.START_GAME)

# ------------------------------------------------------------------------------------------------ #

## Used to change the current state of the game. When called, the state will be changed to the passed
## in state, the appropriate signal will be emitted, and then any code that GameManager needs to run 
## for that state will be executed.
func _change_state(new_state: GameState):
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
		GameState.WIN:
			SignalBus.emit_signal("state_changed_win")
		GameState.LOSE:
			SignalBus.emit_signal("state_changed_lose")

# -- Public Functions -- #



