extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

var _total_score: int = 0

var _piece_values: Dictionary = {
	"player_pawn": 1,
	"player_bishop": 3,
	"player_knight": 3,
	"player_rook": 5,
	"player_queen": 9,
	"player_king": 20,
	"enemy_pawn": -1,
	"enemy_bishop": -3,
	"enemy_knight": -3,
	"enemy_rook": -5,
	"enemy_queen": -9,
	"enemy_king": -20
}

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("state_changed_scoring", _on_state_changed_scoring)
	
# ------------------------------------------------------------------------------------------------ #

func _score_game(signal_arguments: Dictionary) -> void:
	var _final_board: Array = signal_arguments.final_board

	# Score each piece on the board
	for i in _final_board.size():
		for j: int in _final_board[i].size():

			var piece: Node = _final_board[j][i]
			_total_score += _piece_values[piece.piece_name]

			SignalBus.emit_signal("piece_scored", _piece_values[piece.piece_name])
			piece.play_sound_score()
			await _tween_scoring_piece(piece)

	SignalBus.emit_signal("end_game_score_calculated", _total_score)

	GameManager.change_state(GameManager.GameState.GAME_OVER)

# ------------------------------------------------------------------------------------------------ #

func _tween_scoring_piece(piece: Node) -> void:
	# This is probably not the way to do this, but it works. Basically, just setting the Z index super
	# high for the piece that we are going to tween, so that it's guaranteed to be in front of the
	# other pieces. Again, probably a much better way to do this, but it works.
	var original_z_index: int = piece.z_index
	piece.z_index = 100

	var tween := create_tween()
	tween.tween_property(piece, "position:y", -20, 0.15).set_trans(Tween.TRANS_QUAD).as_relative()
	tween.tween_property(piece, "position:y", 20, 0.15).set_trans(Tween.TRANS_QUAD).as_relative()
	await tween.finished

	# Again, probably not the best way to do this. But we want to set the z_index back to it's
	# original value
	piece.z_index = original_z_index

# ------------------------------------------------------------------------------------------------ #

func _on_state_changed_scoring(signal_arguments: Dictionary) -> void:
	# This wait should be about the amount of time it takes for "_initiate_ui()" in "end_game_scorer_ui.gd"
	# to finish. That way we fully slide the scoring panel out before we start scoring.
	# TODO: This is a really terrible way to do this and we should definitely make it better!
	await get_tree().create_timer(1).timeout
	_score_game(signal_arguments)

# ------------------------------------------------------------------------------------------------ #
