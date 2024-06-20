extends ColorRect

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const SETTINGS_SCENE_PATH: String = "res://Scenes/Screens/settings_screen.tscn"

var main_scene: Node = preload("res://Scenes/main.tscn").instantiate()

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	var display_high_score: int = ResourceManager.save_data.high_score
	print("Display high score: ", display_high_score)
	
	# First ever score (before ever playing) is -999. Just display 0 if it's the first time playing. A new score will get overwritten after
	# finishing the first game
	if display_high_score == -999:
		display_high_score = 0

	$MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/HighScoreNumber.text = str(display_high_score)

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
