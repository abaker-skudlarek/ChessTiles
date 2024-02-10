extends Node

func _input(event):
	if event.is_action_pressed("mouse_click"):
		if event.button_index == 1:
			print(event.position)
	
