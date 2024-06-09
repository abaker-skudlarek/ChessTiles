extends ColorRect

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const SETTINGS_SCENE_PATH: String = "res://Scenes/Screens/settings_screen.tscn"

var main_scene: Node = preload("res://Scenes/main.tscn").instantiate()

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _on_start_button_pressed() -> void:
	get_tree().root.add_child(main_scene)
	GameManager.change_state(GameManager.GameState.START_GAME)
	queue_free()

# ------------------------------------------------------------------------------------------------ #

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file(SETTINGS_SCENE_PATH)

# ------------------------------------------------------------------------------------------------ #

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# ------------------------------------------------------------------------------------------------ #
