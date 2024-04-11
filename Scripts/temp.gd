extends Node

func _init() -> void:
	wait()

func wait() -> void:
	print("waiting")
	await get_tree().create_timer(10.0).timeout
	print("done waiting")
