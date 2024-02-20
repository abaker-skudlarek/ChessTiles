extends Node

var square: Variant
	
func _enter_tree() -> void:
	SignalBus.connect("light_square_clicked", _on_light_square_clicked)
	
func _on_spawn_pressed() -> void:
	
	square = ResourceManager.squares["light"].instantiate()
	#var square: Variant = square_resource.instantiate()
	square.position = Vector2(100, 100)
	add_child(square)	
	
func _on_enable_pressed() -> void:
	square.enable_move_overlay()

func _on_disable_pressed() -> void:
	square.disable_move_overlay()
	
func _on_light_square_clicked(square_position: Vector2) -> void:
	print("square position: ", square_position)
