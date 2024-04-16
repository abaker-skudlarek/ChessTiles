extends PanelContainer

@onready var _final_score_sign: Label = $VBoxContainer/HBoxContainer/FinalScoreSignLabel
@onready var _final_score_total: Label = $VBoxContainer/HBoxContainer/FinalScoreTotalLabel

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _enter_tree() -> void:
	visible = false
	SignalBus.connect("state_changed_game_over", _on_state_changed_game_over)
	SignalBus.connect("end_game_score_calculated", _on_end_game_score_calculated)

# ------------------------------------------------------------------------------------------------ #

func _on_state_changed_game_over() -> void:
	visible = true

# ------------------------------------------------------------------------------------------------ #

func _on_end_game_score_calculated(final_score: int) -> void:
	_final_score_total.text = str(abs(final_score))
	if final_score < 0:
		_final_score_sign.text = "-"	
	else:
		_final_score_sign.text = ""

# ------------------------------------------------------------------------------------------------ #

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# ------------------------------------------------------------------------------------------------ #
