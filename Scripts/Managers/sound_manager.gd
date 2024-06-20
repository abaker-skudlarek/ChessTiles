extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const AUDIO_BUS_NAME: String = "Master"

@onready var _audio_bus: int = AudioServer.get_bus_index(AUDIO_BUS_NAME)

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("music_volume_updated", _on_music_volume_updated)

	AudioServer.set_bus_volume_db(_audio_bus, linear_to_db(SaveDataManager.save_data.music_volume))

# ------------------------------------------------------------------------------------------------ #

func _on_music_volume_updated(volume: float) -> void:
	AudioServer.set_bus_volume_db(_audio_bus, linear_to_db(volume))

