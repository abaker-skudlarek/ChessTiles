extends PanelContainer

const RED: Color = Color(1, 0.306, 0.376)
const GREEN: Color = Color(0.082, 0.639, 0.078)

var _total_score: int = 0

@onready var _total_score_label: Label = $HBoxContainer/TotalScoreLabel
@onready var _total_score_sign_label: Label = $HBoxContainer/TotalScoreSignLabel
@onready var _delta_sign_label: Label = $HBoxContainer/DeltaSignLabel
@onready var _delta_score_label: Label = $HBoxContainer/DeltaScoreLabel

# TODO: To make a + or - number move from the piece that's being scored to the score panel, 
# 		and make it curve on it's way there, we can use a Bezier curve 
#		https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html#quadratic-bezier

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	visible = false
	SignalBus.connect("state_changed_scoring", _on_state_changed_scoring)	
	SignalBus.connect("state_changed_game_over", _on_state_changed_game_over)
	SignalBus.connect("piece_scored", _on_piece_scored)	

# ------------------------------------------------------------------------------------------------ #

func _initiate_ui() -> void:
	visible = true
	await get_tree().create_timer(0.75).timeout
	var tween := create_tween()
	tween.tween_property(self, "position:y", -38, 0.3).set_trans(Tween.TRANS_QUAD).as_relative()
	await tween.finished
	await get_tree().create_timer(0.75).timeout

# ------------------------------------------------------------------------------------------------ #

func _remove_ui() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(self, "position:y", 38, 0.3).set_trans(Tween.TRANS_QUAD).as_relative()
	await tween.finished
	visible = false

# ------------------------------------------------------------------------------------------------ #

func _score_piece(piece_value: int) -> void:
	_total_score += piece_value

	# Update the sign based on the value of the piece
	if piece_value < 0:
		_delta_sign_label.text = "-"	
		_delta_sign_label.add_theme_color_override("font_color", RED)
		_delta_score_label.add_theme_color_override("font_color", RED)
	else:
		_delta_sign_label.text = "+"
		_delta_sign_label.add_theme_color_override("font_color", GREEN)
		_delta_score_label.add_theme_color_override("font_color", GREEN)

	# Update the delta score label
	_delta_score_label.text = str(abs(piece_value))

	# Add a "-" sign next to the total score if the score is negative
	if _total_score < 0:
		_total_score_sign_label.text = "-"
	else:
		_total_score_sign_label.text = ""
	
	# Update the total score label 
	_total_score_label.text = str(abs(_total_score))

# ------------------------------------------------------------------------------------------------ #

func _on_state_changed_scoring(_signal_arguments: Dictionary) -> void:
	_initiate_ui()

# ------------------------------------------------------------------------------------------------ #

func _on_state_changed_game_over() -> void:
	_remove_ui()

# ------------------------------------------------------------------------------------------------ #

func _on_piece_scored(piece_value: int) -> void:
	_score_piece(piece_value)

# ------------------------------------------------------------------------------------------------ #
