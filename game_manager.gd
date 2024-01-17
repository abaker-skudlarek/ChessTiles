extends Node

'''
This Scene/File will manage the game. It will keep track of the current state that the game is in
and use signals every time the state is changed. Subscribers will then take actions based on the
state that the game is now in.
'''

# -- Variables -- #

# TODO: Might not need every single one of these
signal state_changed_start_game
signal state_changed_waiting_user_input
signal state_changed_slide_move
signal state_changed_chess_move
signal state_changed_win
signal state_changed_lose

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
			state_changed_start_game.emit()
		GameState.WAITING_USER_INPUT:
			state_changed_waiting_user_input.emit()
		GameState.SLIDE_MOVE:
			state_changed_slide_move.emit()
		GameState.CHESS_MOVE:
			state_changed_chess_move.emit()
		GameState.WIN:
			state_changed_win.emit()
		GameState.LOSE:
			state_changed_lose.emit()

# -- Public Functions -- #



