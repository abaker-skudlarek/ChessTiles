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
	_display_high_score()

# ------------------------------------------------------------------------------------------------ #

func _display_high_score() -> void:
	var display_high_score: int = SaveDataManager.save_data.high_score
	
	# If the SaveData's score is the default score, display "Not Set". This means that it's the first time playing,
	# and the default score will be updated after finishing the first game
	if display_high_score == SaveData.DEFAULT_HIGH_SCORE:
		$MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/HighScoreNumber.text = "Not Set"
	else:
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
