extends Node

func _input(event):
	
	if event.is_action_pressed("slide_move_left"):
		print("slide move left")
		SignalBus.emit_signal("slide_move_left")
	
	if event.is_action_pressed("slide_move_right"):
		print("slide move right")
		SignalBus.emit_signal("slide_move_right")
		
	if event.is_action_pressed("slide_move_up"):
		print("slide move up")
		SignalBus.emit_signal("slide_move_up")
		
	if event.is_action_pressed("slide_move_down"):
		print("slide move down")
		SignalBus.emit_signal("slide_move_down")
