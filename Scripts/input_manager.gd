extends Node

func _input(event):
	if event.is_action_pressed("slide_move_left"):
		print("slide move left")
	
	if event.is_action_pressed("slide_move_right"):
		print("slide move right")
		
	if event.is_action_pressed("slide_move_up"):
		print("slide move up")
		
	if event.is_action_pressed("slide_move_down"):
		print("slide move down")
