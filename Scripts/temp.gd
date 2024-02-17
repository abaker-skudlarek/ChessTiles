extends Node

func _init() -> void:
	var a := Vector2(1, 1)
	var b := Vector2(-1, 0)
	
	print(a + a)
	print(a + b)
