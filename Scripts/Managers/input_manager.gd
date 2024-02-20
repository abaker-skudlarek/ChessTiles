extends Node

# NOTE: This is mainly for more global controls. If you are looking for things like clicking a piece,
# 		a square, etc, those can be found in their respective scripts.

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _input(event: InputEvent) -> void:
	
	# If we aren't waiting for user input, return and do nothing
	if GameManager.get_current_game_state() != GameManager.GameState.WAITING_USER_INPUT:
		return
	
	# TODO: It's possible to do two quick movements really fast, would like to make sure that isn't allowed
	#		Need some sort of wait, or maybe when we have animations we can make it so you can't move
	# 		until the animation is done
	# TODO: Need to prevent diagonal moves
	
	if event.is_action_pressed("slide_move_left"):
		SignalBus.emit_signal("slide_move_left")
	
	if event.is_action_pressed("slide_move_right"):
		SignalBus.emit_signal("slide_move_right")
		
	if event.is_action_pressed("slide_move_up"):
		SignalBus.emit_signal("slide_move_up")
		
	if event.is_action_pressed("slide_move_down"):
		SignalBus.emit_signal("slide_move_down")
		
	
