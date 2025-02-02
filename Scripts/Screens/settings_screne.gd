extends ColorRect

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const TITLE_SCREEN_SCENE_PATH: String = "res://Scenes/Screens/title_screen.tscn"

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	$MarginContainer/AllElementsContainer/MusicContainer/MusicSlider.value = SaveDataManager.save_data.music_volume

# ------------------------------------------------------------------------------------------------ #

func _on_ok_button_pressed() -> void:
	get_tree().change_scene_to_file(TITLE_SCREEN_SCENE_PATH)