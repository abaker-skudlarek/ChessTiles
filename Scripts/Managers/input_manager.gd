extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

var _min_swipe_length: int = 25  # The amount of pixels that need to be swiped over to detect the swipe
var _swipe_start_position: Vector2
var _swipe_current_position: Vector2
var _swipe_divergence_threshold: int = 10  # The amount of pixels that the swipe needs to stay within, to detect a horizontal
										  # or vertical swipe. If the swipe diverges more than this amount of pixels, it 
										  # will not be detected. Prevents diagonal swipes
var _is_swiping: bool = false

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _process(_delta: float) -> void:
	_swipe_detection()

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

# ------------------------------------------------------------------------------------------------ #

func _swipe_detection() -> void:
	if Input.is_action_just_pressed("mouse_click"):
		if !_is_swiping:
			_is_swiping = true
			_swipe_start_position = get_viewport().get_mouse_position()	
			print("Start position: ", _swipe_start_position)
	if Input.is_action_pressed("mouse_click"):
		if _is_swiping:
			_swipe_current_position = get_viewport().get_mouse_position()
			if _swipe_start_position.distance_to(_swipe_current_position) >= _min_swipe_length:
				if abs(_swipe_start_position.y - _swipe_current_position.y) <= _swipe_divergence_threshold:
					print("Horizontal swipe detected")
					if _swipe_start_position.x < _swipe_current_position.x:
						print("Swipe right detected")
						SignalBus.emit_signal("slide_move_right")
					else:
						print("Swipe left detected")
						SignalBus.emit_signal("slide_move_left")
					_is_swiping = false
				elif abs(_swipe_start_position.x - _swipe_current_position.x) <= _swipe_divergence_threshold:
					print("Vertical swipe detected")
					if _swipe_start_position.y < _swipe_current_position.y:
						print("Swipe down detected")
						SignalBus.emit_signal("slide_move_down")
					else:
						print("Swipe up detected")
						SignalBus.emit_signal("slide_move_up")
					_is_swiping = false
	else:
		_is_swiping = false


# ------------------------------------------------------------------------------------------------ #
