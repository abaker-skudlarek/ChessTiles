extends HSlider

func _on_value_changed(new_value: float) -> void:
	SignalBus.emit_signal("music_volume_updated", new_value)
