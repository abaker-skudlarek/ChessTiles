extends HSlider

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const AUDIO_BUS_NAME: String = "Master"

@onready var _audio_bus: int = AudioServer.get_bus_index(AUDIO_BUS_NAME)

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(_audio_bus, linear_to_db(new_value))
