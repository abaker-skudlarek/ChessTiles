extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

# TODO: In a more in depth game, we should split game data and settings data into various different files
const SAVE_DATA_FILE = "user://save_data.json"

var save_data := SaveData.new()

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("new_high_score", _on_new_high_score)
	SignalBus.connect("music_volume_updated", _on_music_volume_changed)

	# If the file doesn't exist, create it an call save() to populate it with default values
	if !FileAccess.file_exists(SAVE_DATA_FILE):
		FileAccess.open(SAVE_DATA_FILE, FileAccess.WRITE)
		save_file(SAVE_DATA_FILE)

	# Load up the file when we start up the save data manager
	# TODO: In a more complex game, we may want to load specific data at other points. But for this one, 
	# 		we are fine with just loading it once at the start of the game
	load_file(SAVE_DATA_FILE)

# ------------------------------------------------------------------------------------------------ #

func _on_new_high_score(score: int) -> void:
	save_data.high_score = score
	save_file(SAVE_DATA_FILE)  # TODO: Maybe calling save() here is bad? In a more complex game, we'd want something more sophisticated

# ------------------------------------------------------------------------------------------------ #

func _on_music_volume_changed(volume: float) -> void:
	save_data.music_volume = volume
	save_file(SAVE_DATA_FILE)  # TODO: Maybe calling save() here is bad? In a more complex game, we'd want something more sophisticated

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

func save_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return

	var data := {
		"save_data": {
			"high_score": save_data.high_score,
		},
		"settings_data": {
			"music_volume": save_data.music_volume
		}
	}

	var json_string := JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

# ------------------------------------------------------------------------------------------------ #

func load_file(path: String) -> void:
	if !FileAccess.file_exists(path):
		print("Cannot open non-existent file at ", path)
		return	

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		print(FileAccess.get_open_error())
		return

	var content := file.get_as_text()
	file.close()

	var data: Variant = JSON.parse_string(content)
	if data == null:
		printerr("Cannot parse %s as a JSON string: (%s)" % [path, content])
		return
	
	# TODO: In a more in depth game/implementation, this could be broken out into a function or set of functions.
	# 		Could even make it so that we dynamically apply save data to the correct objects based on the content of 
	# 		the JSON. Since, the JSON keys should match exactly to the object variable names
	save_data = SaveData.new()
	save_data.high_score = data.save_data.high_score
	save_data.music_volume = data.settings_data.music_volume

# ------------------------------------------------------------------------------------------------ #
