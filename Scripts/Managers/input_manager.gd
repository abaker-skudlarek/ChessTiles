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
var _input_allowed: bool = true


# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("slide_move_finished", _on_slide_move_finished)
	SignalBus.connect("chess_move_finished", _on_chess_move_finished)

# ------------------------------------------------------------------------------------------------ #

func _process(_delta: float) -> void:
	_swipe_detection()

# ------------------------------------------------------------------------------------------------ #

func _input(event: InputEvent) -> void:	
	if !_input_allowed:
		print("moving is not allowed")
		return

	# If we aren't waiting for user input, return and do nothing
	if GameManager.get_current_game_state() != GameManager.GameState.WAITING_USER_INPUT:
		return
	
	# TODO: It's possible to do two quick movements really fast, would like to make sure that isn't allowed
	#		Need some sort of wait, or maybe when we have animations we can make it so you can't move
	# 		until the animation is done
	# TODO: Need to prevent diagonal moves
	
	if event.is_action_pressed("slide_move_left"):
		_input_allowed = false
		print("_input_allowed: ", _input_allowed)
		SignalBus.emit_signal("slide_move_left")
	
	if event.is_action_pressed("slide_move_right"):
		_input_allowed = false
		print("_input_allowed: ", _input_allowed)
		SignalBus.emit_signal("slide_move_right")
		
	if event.is_action_pressed("slide_move_up"):
		_input_allowed = false
		print("_input_allowed: ", _input_allowed)
		SignalBus.emit_signal("slide_move_up")
		
	if event.is_action_pressed("slide_move_down"):
		_input_allowed = false
		print("_input_allowed: ", _input_allowed)
		SignalBus.emit_signal("slide_move_down")

# ------------------------------------------------------------------------------------------------ #

func _swipe_detection() -> void:
	if Input.is_action_just_pressed("mouse_click"):
		if !_is_swiping:
			_is_swiping = true
			_swipe_start_position = get_viewport().get_mouse_position()	
	if Input.is_action_pressed("mouse_click"):
		if _is_swiping:
			_swipe_current_position = get_viewport().get_mouse_position()
			if _swipe_start_position.distance_to(_swipe_current_position) >= _min_swipe_length:
				if abs(_swipe_start_position.y - _swipe_current_position.y) <= _swipe_divergence_threshold:
					if _swipe_start_position.x < _swipe_current_position.x:
						SignalBus.emit_signal("slide_move_right")
					else:
						SignalBus.emit_signal("slide_move_left")
					_is_swiping = false
				elif abs(_swipe_start_position.x - _swipe_current_position.x) <= _swipe_divergence_threshold:
					if _swipe_start_position.y < _swipe_current_position.y:
						SignalBus.emit_signal("slide_move_down")
					else:
						SignalBus.emit_signal("slide_move_up")
					_is_swiping = false
	else:
		_is_swiping = false

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_finished() -> void:
	_input_allowed = true
	print("_input_allowed: ", _input_allowed)

# ------------------------------------------------------------------------------------------------ #

func _on_chess_move_finished() -> void:
	_input_allowed = true
	print("_input_allowed: ", _input_allowed)

# ------------------------------------------------------------------------------------------------ #
