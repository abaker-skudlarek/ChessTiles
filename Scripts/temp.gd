extends Node

func _init() -> void:
	var a: int = 10
	print(a)

	if a < 0:
		print("negative")
	else:
		print("positive")
